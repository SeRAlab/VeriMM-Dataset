module mux_2to1_8bit(
    input sel,
    input [7:0] d0,
    input [7:0] d1,
    output [7:0] y
);
    assign y = sel ? d1 : d0;
endmodule