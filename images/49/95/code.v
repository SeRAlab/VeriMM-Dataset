module top_module(wejscieA, wejscieB, Q);parameter szerokosc = 4;
input [szerokosc-1:0] wejscieA, wejscieB;
output [szerokosc-1:0] Q;

   wire [szerokosc-1:0] wejscieA;
   wire [szerokosc-1:0] wejscieB;
   wire [szerokosc-1:0] Q;
    assign Q = wejscieA + wejscieB;endmodule