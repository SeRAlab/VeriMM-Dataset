module binary_adder (
  input [3:0] A,
  input [3:0] B,
  input Cin,
  input clk,
  input rst_n,
  output [3:0] S,
  output Cout
);

  reg [3:0] S;
  reg Cout;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      S <= 4'b0;
      Cout <= 1'b0;
    end else begin
      {Cout, S} <= A + B + Cin;
    end
  end

endmodule