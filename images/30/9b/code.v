module mux_16bit (
    input wire [15:0] data_in0,
    input wire [15:0] data_in1,
    input wire sel,
    output wire [15:0] data_out
);

assign data_out = (sel == 0) ? data_in0 : data_in1;

endmodule