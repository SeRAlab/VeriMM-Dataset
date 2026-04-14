module top_module(
  input [7:0] A,
  input [7:0] B,
  input cin,
  input reset,
  output reg [8:0] sum,
  output reg cout
);// variable declaration
reg [8:0] temp_sum;
reg temp_cout;

// synchronous reset
always @(posedge reset) begin
  sum <= 9'b0;
  cout <= 1'b0;
end

// core logic
always @(A or B or cin) begin
  temp_sum = A + B + cin;
  temp_cout = (temp_sum > 8'b11111111) ? 1'b1 : 1'b0;
  sum <= temp_sum;
  cout <= temp_cout;
end

endmodule