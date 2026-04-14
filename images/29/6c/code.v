module mux_2x1 (
    input wire [15:0] data0,
    input wire [15:0] data1,
    input wire sel,
    output wire [15:0] out
);
    assign out = sel ? data1 : data0;
endmodule