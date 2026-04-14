module mux_2to1(sel, a, b, y);
    input sel, a, b;
    output y;

    assign y = sel ? b : a;
endmodule