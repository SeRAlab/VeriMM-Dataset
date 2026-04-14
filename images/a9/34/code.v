module top_module(
    input [3:0] A,
    input [3:0] B,
    input op,
    output reg [3:0] C
);always @(A, B, op) begin
        case(op)
            1'b0: C <= A + B;
            1'b1: C <= A - B;
        endcase
        
        if(C > 15 || C < -8) // check for overflow or underflow
            C[3] <= 1;
        else
            C[3] <= 0;
    end

endmodule