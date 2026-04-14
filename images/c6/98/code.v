module mux_2to1 (
    input [1:0] data_in,
    input sel,
    output data_out
);

    assign data_out = (sel == 1'b0) ? data_in[0] : data_in[1];

endmodule