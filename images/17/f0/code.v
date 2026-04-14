module mux_2bit (
    input [1:0] a,      // 2-bit input a
    input [1:0] b,      // 2-bit input b
    input sel,          // 1-bit select signal
    output [1:0] out    // 2-bit output
);
    assign out = (sel) ? b : a;
endmodule