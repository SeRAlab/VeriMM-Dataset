module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift,
    output [3:0] data_out
);

    assign data_out = (shift == 2'b00) ? data_in :
                      (shift == 2'b01) ? {data_in[2:0], 1'b0} :
                      (shift == 2'b10) ? {1'b0, data_in[3:1]} :
                      {2'b00, data_in[3:2]};
                      
endmodule