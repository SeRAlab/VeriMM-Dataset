module top_module(
    input [3:0] data_in,
    input [1:0] shift_amount,
    output [3:0] out
);assign out = (shift_amount == 0) ? data_in :
                 (shift_amount == 1) ? {data_in[0], data_in[3:1]} :
                 (shift_amount == 2) ? {data_in[1:0], data_in[3:2]} :
                 (shift_amount == 3) ? {data_in[2:0], data_in[3]} :
                 4'b0000;

endmodule