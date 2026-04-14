module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] SUM,
    output COUT
);

wire [3:0] sum_temp;
assign sum_temp = A + B + CIN;
assign SUM = sum_temp[3:0];
assign COUT = (sum_temp > 4'h9) ? 1'b1 : 1'b0;

endmodule