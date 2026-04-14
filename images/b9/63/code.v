module decoder_2to4 (
    input wire [1:0] data_in,
    output wire [3:0] data_out
);

    assign data_out = (data_in == 2'b00) ? 4'b0001 :
                      (data_in == 2'b01) ? 4'b0010 :
                      (data_in == 2'b10) ? 4'b0100 :
                                          4'b1000;

endmodule