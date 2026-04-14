module top_module(
    input  [3:0] A,
    input  [3:0] B,
    input  [3:0] C,
    input  [3:0] D,
    input        S,
    output [3:0] Q
);wire [3:0] sum;
    
    assign sum = (S == 0) ? A + B + C + D : A - B - C - D;
    
    assign Q = sum;
endmodule