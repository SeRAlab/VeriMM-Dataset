module mux_16bit (
    input wire [15:0] data_a,
    input wire [15:0] data_b,
    input wire select,
    output wire [15:0] out
);
    assign out = (select) ? data_b : data_a;
endmodule