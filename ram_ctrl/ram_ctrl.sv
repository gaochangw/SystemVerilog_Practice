`timescale 1ps/1ps
`include "config.sv"

// Potential Collisions
    // 1. Write Request Bank Confliction
    // 2. Read Request Bank Confliction

module ram_ctrl #(
    parameter RAM_WIDTH    = 8,
    parameter RAM_DEPTH    = 256,
    parameter N_REQUESTORS = 2,
    parameter N_BANKS      = 2
) (
    input   logic                                                 clk,   // Clock
    input   logic                                                 rst_n, // Active Low
    // Request Channels
    input   logic [N_REQUESTORS-1:0]                              s_wreq_axis_tvalid_i,
    input   logic [N_REQUESTORS-1:0][WIDTH_RAM_CTRL_INST_REQ-1:0] s_wreq_axis_tdata_i,
    output  logic [N_REQUESTORS-1:0]                              s_wreq_axis_tready_o,
    // Write Data Channels
    input   logic [N_REQUESTORS-1:0]                              s_wdata_axis_tvalid_i,
    input   logic [N_REQUESTORS-1:0][RAM_WIDTH-1:0]               s_wdata_axis_tdata_i,
    input   logic [N_REQUESTORS-1:0][RAM_WIDTH-1:0]               s_wdata_axis_tlast_i,
    output  logic [N_REQUESTORS-1:0]                              s_wdata_axis_tready_o,
    // Read Data Channels
    output  logic [N_REQUESTORS-1:0]                              m_rdata_axis_tvalid_o,
    output  logic [N_REQUESTORS-1:0][RAM_WIDTH-1:0]               m_rdata_axis_tdata_o,
    output  logic [N_REQUESTORS-1:0]                              m_rdata_axis_tlast_o,
    input   logic [N_REQUESTORS-1:0]                              m_rdata_axis_tready_i
);
    // Local Parameters
    localparam RAM_ADDR_BW = $clog2(RAM_DEPTH);

    
    
    
    
    
    // Signals
    logic                   ram_clk;
    logic [RAM_WIDTH-1:0]   ram_din  [NUM_BANKS-1:0];
    logic [RAM_ADDR_BW-1:0] ram_addr [NUM_BANKS-1:0];
    logic                   ram_cen  [NUM_BANKS-1:0];
    logic                   ram_wen  [NUM_BANKS-1:0];
    logic [RAM_WIDTH-1:0]   ram_dout [NUM_BANKS-1:0];

    // Single-Port RAM Banks
    ram_sp (
        .WIDTH (RAM_WIDTH),
        .DEPTH (RAM_DEPTH),
    ) i_ram [NUM_BANKS-1:0] (
        .clk  (ram_clk ),
        .din  (ram_din ),
        .addr (ram_addr),
        .cen  (ram_cen ),
        .wen  (ram_wen ),
        .dout (ram_dout)
    );


endmodule