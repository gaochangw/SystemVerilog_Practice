module ram_sp #(
  parameter WIDTH = 8,
  parameter DEPTH = 256
) (
  input wire             clk,
  input wire [WIDTH-1:0] din,
  input wire [7:0]       addr,
  input wire             wen,  // Active Low
  output reg [WIDTH-1:0] dout
);
  reg [WIDTH-1:0] mem [0:DEPTH-1];

  always @(posedge clk) begin
    if (wen) begin
      mem[addr] <= din;
    end
  end

  assign dout = mem[addr];
endmodule