module mux_4to1(
    input       a,
    input       b,
    input       c,
    input       d,
    input [1:0] sel,
    output      y
);

assign y = (sel == 2'b00) ? a :
           (sel == 2'b01) ? b :
           (sel == 2'b10) ? c :
           (sel == 2'b11) ? d : 1'b0;

endmodule