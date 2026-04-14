module top_module(S, V, A, B, Cin);output [3:0] S;
    output V;
    input [3:0] A, B;
    input Cin;
    
    wire [3:0] sum;
    wire carry_out;
    
    assign {carry_out, sum} = A + B + Cin;
    assign S = sum;
    assign V = (sum > 4'hF) ? 1 : 0;
endmodule