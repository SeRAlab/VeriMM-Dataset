module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] Sum,
  output Cout
);reg [3:0] temp_sum;
  reg temp_carry;
  
  always @(posedge clk) begin
    if (reset) begin
      temp_sum <= 4'b0;
      temp_carry <= 1'b0;
    end
    else begin
      temp_sum <= A + B + Cin;
      temp_carry <= (temp_sum > 4'b1111) ? 1'b1 : 1'b0;
    end
  end
  
  assign Sum = temp_sum;
  assign Cout = temp_carry;
  
endmodule