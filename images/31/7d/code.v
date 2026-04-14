module mux_2to1 (
    input [3:0] data0,   // First 4-bit data input
    input [3:0] data1,   // Second 4-bit data input
    input sel,           // 1-bit select signal
    output [3:0] out     // 4-bit output
);
    assign out = (sel) ? data1 : data0; // Select data based on sel
endmodule