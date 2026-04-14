module mux_4to1 (
    input a,
    input b,
    input c,
    input d,
    input [1:0] sel,
    output y
);

    // 4-to-1 MUX logic
    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c :
                                d;

endmodule