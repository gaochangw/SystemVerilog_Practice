module ram_sp #(
  parameter WIDTH = 8,
  parameter DEPTH = 256
) (
    input wire                     clk,
    input wire [WIDTH-1:0]         din,
    input wire [$clog2(DEPTH)-1:0] addr,
    input wire                     cen,  // Active Low
    input wire                     wen,  // Active Low
    output reg [WIDTH-1:0]         dout
);
    reg [WIDTH-1:0] mem [DEPTH-1:0];

    always @(posedge clk) begin
        if (!cen) begin
            if (!wen) begin
                mem[addr] <= din;
            end else begin
                dout <= mem[addr];
            end
        end
    end
endmodule