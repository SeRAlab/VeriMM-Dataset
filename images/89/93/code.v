module top_module(
    input [15:0] in,
    input [3:0] shift_amount,
    output [15:0] out
);assign out = (shift_amount >= 0) ? (in << shift_amount) : (in >> -shift_amount);

endmodule