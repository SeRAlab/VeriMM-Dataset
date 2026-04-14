module bitwise_and (
    input [15:0] data_in,
    input [15:0] mask,
    input enable,
    output [15:0] data_out
);

    assign data_out = enable ? (data_in & mask) : data_in;

endmodule