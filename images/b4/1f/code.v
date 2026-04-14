module barrel_shifter(
    input [3:0] data_in,
    input [1:0] shift_amt,
    output [3:0] data_out
);
    assign data_out = (shift_amt == 2'd0) ? data_in :
                      (shift_amt == 2'd1) ? {data_in[2:0], data_in[3]} :
                      (shift_amt == 2'd2) ? {data_in[1:0], data_in[3:2]} :
                      {data_in[0], data_in[3:1]};
endmodule