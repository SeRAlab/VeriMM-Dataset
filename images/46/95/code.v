module verified_mux2_to_1(a, b, sel, y);

    input a;
    input b;
    input sel;
    output reg y;

    always @(*)
        begin
            if (sel)
                y = b;
            else
                y = a;
        end  

endmodule