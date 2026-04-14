module top_module(
    input [1:0] data_i,
    output [1:0] data_o
    );assign data_o[1] = data_i[1];
    assign data_o[0] = ~data_i[1] & data_i[0];endmodule