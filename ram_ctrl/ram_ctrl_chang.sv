module ram_ctrl #(
    parameter WIDTH        = 8,
    parameter DEPTH        = 256,
    parameter N_REQUESTORS = 2
) (
    input  logic                                         clk,  // Clock
    input  logic [N_REQUESTORS-1:0][WIDTH-1:0]           din,  // Data In
    input  logic [N_REQUESTORS-1:0][$clog2(DEPTH)-1:0]   addr, // Address
    input  logic [N_REQUESTORS-1:0]                      rw,   // 0 for Write, 1 for Read
    input  logic [N_REQUESTORS-1:0]                      req,  // Active High
    output logic [N_REQUESTORS-1:0][$clog2(DEPTH)-1-1:0] dout  // Data Out
);

    localparam WIDTH_N_REQUESTORS = clog2(N_REQUESTORS);

    logic [WIDTH_N_REQUESTORS-1:0] current_req;

    // Handle read and write requests from each requestor in a round-robin fashion
    always_ff @(posedge clk) begin
        current_req <= current_req + 1'b1;
        for (int i = 0; i < N_REQUESTORS; i = i + 1) begin
            if (req[(i + current_req) % N_REQUESTORS]) begin
                if (rw[(i + current_req) % N_REQUESTORS]) begin
                    mem[addr[(i + current_req) % N_REQUESTORS]] <= din[(i + current_req) % N_REQUESTORS];
                end else begin
                    dout[(i + current_req) % N_REQUESTORS] <= mem[addr[(i + current_req) % N_REQUESTORS]];
                end
            end
        end
    end

    ram_sp (
        .WIDTH (WIDTH),
        .DEPTH (DEPTH),
    ) i_ram (
        .clk  (),
        .din  (),
        .addr (),
        .wen  (),  // Active Low
        .dout ()
);
endmodule