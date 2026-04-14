module mux2to1(a, b, sel, y);
    input a;
    input b;
    input sel;
    output y;

    assign y = sel ? b : a;
endmodule