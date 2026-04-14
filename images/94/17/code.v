module top_module(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);wire [7:0] temp_sum;
wire [7:0] temp_carry;

assign temp_sum = a ^ b;
assign temp_carry = a & b;

assign sum = temp_sum ^ cin;
assign cout = temp_carry | (temp_sum & cin);

endmodule