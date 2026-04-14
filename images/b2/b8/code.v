module top_module(output reg [31:0] Y, input S, input [31:0] A, B);always @ (*)
        if (!S) Y = B;
        else Y = A;endmodule