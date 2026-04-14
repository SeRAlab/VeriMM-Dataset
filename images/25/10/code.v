module barrel_shifter (
    input [1:0] data_in,
    input ctrl,
    output [1:0] data_out
);
    assign data_out = (ctrl == 0) ? {data_in[0], data_in[1]} : {data_in[1], data_in[0]};
endmodule