module top_module(in1, in2, carry_in, carry_out, sum);input [1:0] in1, in2;
input carry_in;
output reg [1:0] sum;
output reg carry_out;
reg [2:0] inter_calc_result;



always@(*) begin
  inter_calc_result = in1 + in2 + carry_in;
  sum = inter_calc_result[1:0];
  carry_out = inter_calc_result[2];
end

endmodule