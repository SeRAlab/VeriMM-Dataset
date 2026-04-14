module mux_4to1(
    input a, b, c, d, 
    input [1:0] sel, 
    output y);

    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c :
                                d;
endmodule