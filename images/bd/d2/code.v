module mux_2to1(a, b, sel, y);

    input a;
    input b;
    input sel;
    output y;
    reg y;

    always @(*)
        begin
            y <= (sel) ? b : a;
        end

endmodule