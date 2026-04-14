module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] op,
    output reg [3:0] P // Changed 'output [3:0] P' to 'output reg [3:0] P'
);always @(*) begin
        case(op[2:1])
            2'b00: P = A + B; // addition
            2'b01: P = A - B; // subtraction
            2'b10: P = A & B; // bitwise AND
            2'b11: P = A | B; // bitwise OR
        endcase
        
        if(op[0] == 1) begin // signed output
            if(op[2:1] == 2'b01) begin // subtraction
                if(A[3] == 1 && B[3] == 0 && P[3] == 0) begin // overflow
                    P[3] = 1;
                end
                else if(A[3] == 0 && B[3] == 1 && P[3] == 1) begin // underflow
                    P[3] = 0;
                end
            end
        end
    end

endmodule