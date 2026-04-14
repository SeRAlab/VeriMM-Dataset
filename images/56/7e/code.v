module mux_2to1(a, b, sel, y);

    input a;
    input b;
    input sel;
    output y;
    reg y;

    always @(*)
        begin
            if (sel == 0)
                y = a;
            else
                y = b;
        end

endmodule