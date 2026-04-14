module top_module(input [3:0] A, B, C, output [3:0] O, output CO, OV);wire [4:0] temp;
    wire cin, cout;
    assign cin = ~C;
    
    // Adder/Subtractor
    assign temp = {cin, A} + {~C, B};
    assign O = temp[3:0];
    assign CO = temp[4];
    
    // Overflow detection
    assign OV = (A[3] & B[3] & ~O[3]) | (~A[3] & ~B[3] & O[3]);
endmodule