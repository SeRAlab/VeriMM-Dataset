module top_module(clk, rst, i_pc, o_pc);parameter N = 32;
  input wire clk, rst;
  input wire [N-1:0] i_pc;
  output reg [N-1:0] o_pc;
  always @(posedge clk) begin
if (rst) o_pc <= 0; 

else o_pc <= i_pc; 

  end
endmodule