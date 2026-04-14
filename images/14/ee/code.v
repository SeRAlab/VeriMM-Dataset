module mux_2to1 (
    input wire [15:0] data0,
    input wire [15:0] data1,
    input wire select,
    output wire [15:0] out
);
    assign out = (select) ? data1 : data0;
endmodule