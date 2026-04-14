module barrel_shifter (
    input [7:0] in,
    input [2:0] shift_amount,
    output [7:0] out);

assign out = (in << shift_amount) | (in >> (8 - shift_amount));

endmodule