module top_module(
    input  wire [1 : 0] data_in,
    output wire [1 : 0] data_out
);assign data_out[1]=data_in[1]^data_in[0];
assign data_out[0]=data_in[1];


endmodule