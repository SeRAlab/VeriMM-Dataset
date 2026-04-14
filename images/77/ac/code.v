module barrel_shifter_16bit (
    input wire [15:0] data_in,
    input wire [3:0] shift_amount,
    input wire shift_dir,
    output wire [15:0] data_out
);

    wire [15:0] shift_left, shift_right;

    assign shift_left = data_in << shift_amount;
    assign shift_right = data_in >> shift_amount;
    assign data_out = shift_dir ? shift_right : shift_left;

endmodule