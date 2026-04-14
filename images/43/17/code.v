module mux_4to1 (
    input wire [3:0] data_in,
    input wire [1:0] sel,
    output wire data_out
);

    assign data_out = (sel == 2'b00) ? data_in[0] :
                      (sel == 2'b01) ? data_in[1] :
                      (sel == 2'b10) ? data_in[2] :
                                       data_in[3];

endmodule