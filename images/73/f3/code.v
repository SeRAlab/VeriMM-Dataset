module mux_4to1(
    input in0,          // 1-bit input 0.
    input in1,          // 1-bit input 1.
    input in2,          // 1-bit input 2.
    input in3,          // 1-bit input 3.
    input [1:0] sel,    // 2-bit select signal.

    output out          // 1-bit output.
);

assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
             (sel == 2'b11) ? in3 : 1'b0;

endmodule