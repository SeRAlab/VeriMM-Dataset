module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  input clk,
  input rst_n,
  output reg [3:0] S,  // Change output to reg type
  output reg Cout      // Change output to reg type
);always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      S <= 4'b0;
      Cout <= 1'b0;
    end else begin
      {Cout, S} <= A + B + Cin;
    end
  end

endmodule