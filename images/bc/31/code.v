module barrel_shifter(
    input [31:0] data_in,
    input [4:0] shift_amount,
    input shift_left,
    output [31:0] data_out
    );

    assign data_out = shift_left ? (data_in << shift_amount) : (data_in >> shift_amount);
endmodule