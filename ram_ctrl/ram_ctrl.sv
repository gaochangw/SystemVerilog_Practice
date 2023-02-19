module ram_ctrl #(
    parameter WIDTH        = 8,
    parameter DEPTH        = 256,
    parameter N_REQUESTORS = 2
) (
    input  logic                                         clk,   // Clock
    input  logic                                         rst_n, // Active Low
    input  logic [N_REQUESTORS-1:0][WIDTH-1:0]           din,   // Data In
    input  logic [N_REQUESTORS-1:0][$clog2(DEPTH)-1:0]   addr,  // Address
    input  logic [N_REQUESTORS-1:0]                      rw,    // 0 for Write, 1 for Read
    input  logic [N_REQUESTORS-1:0]                      req,   // Active High
    output logic [N_REQUESTORS-1:0][$clog2(DEPTH)-1-1:0] dout   // Data Out
);


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