module top_module(
output[5:0] O,
input[5:0] A,
input[5:0] B
);wire[5:0] temp;
wire sign;
assign temp = (2 * A - B);
not(sign,temp[5]);
assign O = sign ? temp : -temp;endmodule