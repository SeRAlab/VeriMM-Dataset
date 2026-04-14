module adder_4bit (
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);

  reg [3:0] S;
  reg Cout;
  
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      S <= 4'b0;
      Cout <= 1'b0;
    end else begin
      {Cout, S} <= A + B + Cin;
    end
  end
  
endmodule
