module mux_2to1(a, b, sel, y);

    input a;
    input b;
    input sel;
    output y;
    reg y;

    always @(a or b or sel)
    begin
        if (sel)
            y <= b;
        else
            y <= a;
    end

endmodule