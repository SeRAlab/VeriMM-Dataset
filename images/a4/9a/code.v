module top_module(
  input [7:0] input1,
  input [7:0] input2,
  output reg [15:0] add_output,
  output reg [15:0] sub_output,
  output reg [15:0] mul_output
);always @ (input1 or input2) begin
    add_output <= input1 + input2;
    sub_output <= input1 - input2;
    mul_output <= input1 * input2;
  end
  
endmodule