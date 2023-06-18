`timescale 1ps/1ps
`include "config.sv"

module req_handler #(
    parameter RAM_WIDTH    = 8,
    parameter RAM_DEPTH    = 256,
    parameter N_REQUESTORS = 2,
    parameter N_BANKS      = 2
) (
    input  logic                          clk,   // Clock
    input  logic                          resetn, // Active Low
    input  logic                          en,
    output logic                          ram_cen,  // Active Low
    output logic                          ram_wen,  // Active Low
    output logic  [$clog2(RAM_DEPTH)-1:0] ram_addr,
    output logic  [RAM_WIDTH-1:0]         ram_din,
    input  logic  [RAM_WIDTH-1:0]         ram_dout,
    // Request Channels
    input  logic                               s_req_axis_tvalid_i,
    input  logic [WIDTH_RAM_CTRL_INST_REQ-1:0] s_req_axis_tdata_i,
    input  logic                               s_req_axis_tready_i,
    // Write Data Channels
    input  logic                               s_wdata_axis_tvalid_i,
    input  logic [RAM_WIDTH-1:0]               s_wdata_axis_tdata_i,
    input  logic                               s_wdata_axis_tlast_i,
    input  logic                               s_wdata_axis_tready_o,
    // Read Data Channels
    output logic                               m_rdata_axis_tvalid_o,
    output logic [RAM_WIDTH-1:0]               m_rdata_axis_tdata_o,
    output logic                               m_rdata_axis_tlast_o,
    input  logic                               m_rdata_axis_tready_i
);
    // Local Parameters
    localparam RAM_ADDR_BW = $clog2(RAM_DEPTH);

    // Local Variables
    REQ_TYPE req_type;
    logic [RAM_ADDR_BW-1:0] req_burst_len;
    logic [RAM_ADDR_BW-1:0] req_start_addr;
    assign req_type        = $cast(REQ_TYPE, s_req_axis_tdata_i[WIDTH_RAM_CTRL_INST_REQ-1 -: WIDTH_RAM_CTRL_TYPE]);
    assign req_burst_len   = s_req_axis_tdata_i[WIDTH_RAM_CTRL_INST_REQ-WIDTH_RAM_CTRL_TYPE-1 -: WIDTH_RAM_CTRL_BURST_LEN];
    assign req_start_addr  = s_req_axis_tdata_i[WIDTH_RAM_CTRL_ADDR-1:0];

    // Finite State Machine
    //-----------------------------------------------------
    //-- State Machine - Prime Number Calculator Example
    //-----------------------------------------------------
    typedef enum logic [2:0]   {HAND_IDLE  = 3'b001,
                                HAND_READ  = 3'b010,
                                HAND_WRITE = 3'b100} HAND_STATE;
    HAND_STATE state;

    always_ff @ (posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= HAND_IDLE;
            ram_cen <= 1'b1;
            ram_wen <= 1'b1;
            ram_addr <= 0;
            s_req_axis_tready_i <= 1'b0;
            m_rdata_axis_tdata_o <= '0;
        end else if (en) begin
            s_req_axis_tready_i <= 1'b0;
            case (state)
                HAND_IDLE : begin
                    m_rdata_axis_tvalid_o <= 1'b0;
                    if (s_req_axis_tvalid_i) begin
                        s_req_axis_tready_i <= 1'b1;
                        ram_cen <= 1'b0;
                        ram_wen <= (reg_type == READ) ? 1'b1 : 1'b0;
                        ram_addr <= req_start_addr;
                        state <= (reg_type == READ) ? HAND_READ : HAND_WRITE;
                    end
                end

                HAND_READ : begin
                    m_rdata_axis_tvalid_o <= 1'b1;
                    m_rdata_axis_tdata_o  <= ram_dout;
                    if (req_burst_len == 0) begin
                        // Check if data channel is ready
                        if (m_rdata_axis_tready_i) begin
                            state <= HAND_IDLE;
                            m_rdata_axis_tvalid_o <= 1'b0;
                        end
                        // Check if there is another request
                        if (m_rdata_axis_tready_i & s_req_axis_tvalid_i && req_type == READ) begin
                            status <= HAND_READ;
                            s_req_axis_tready_i <= 1'b1;
                        end
                    end else begin
                        // Check if data channel is ready
                        if (m_rdata_axis_tready_i) begin
                            ram_addr <= ram_addr + 1;
                            if (ram_addr - req_start_addr == req_burst_len) begin
                                state <= HAND_IDLE;
                                // Check if there is another request
                                if (m_rdata_axis_tready_i & s_req_axis_tvalid_i && req_type == READ) begin
                                    status <= HAND_READ;
                                    s_req_axis_tready_i <= 1'b1;
                                    ram_addr <= req_start_addr;
                                end
                            end
                        end
                    end
                end

                HAND_WRITE : begin
                  
                end
                
                default : begin

                end
            endcase
        end
    end


endmodule