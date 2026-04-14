module top_module(
    input [31:0] data_in,
    output [15:0] data_out
);wire [1:0] msb = data_in[31:30];

    assign data_out = (msb == 2'b01) ? data_in[15:0] :
                     (msb == 2'b10) ? data_in[31:16] :
                     (msb == 2'b11) ? ~data_in[31:16] :
                                      ~data_in[15:0];

endmodule