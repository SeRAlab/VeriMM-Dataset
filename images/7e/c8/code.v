module mux_2to1_8bit(sel, a, b, y);

    input  sel;
    input  [7:0] a, b;
    output [7:0] y;

    assign y = sel ? b : a;

endmodule