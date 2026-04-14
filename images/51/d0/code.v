module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] OP,
    output reg [3:0] R,
    output reg OF
);reg [4:0] temp; // Temporary register for multiplication and division
reg [4:0] negB; // Two's complement of B

always @(*) begin
    // Two's complement of B
    negB = (~B) + 1;

    // Addition
    if(OP == 2'b00) begin
        R = A + B;
        OF = (A[3] & B[3] & ~R[3]) | (~A[3] & ~B[3] & R[3]);
    end

    // Subtraction
    else if(OP == 2'b01) begin
        R = A + negB;
        OF = (A[3] & negB[3] & ~R[3]) | (~A[3] & negB[3] & R[3]);
    end

    // Multiplication
    else if(OP == 2'b10) begin
        temp = A * B;
        R = temp[3:0];
        OF = temp[4];
    end

    // Division
    else if(OP == 2'b11) begin
        if(B != 4'b0000) begin // Check for division by zero
            temp = {A, 1'b0} / {B, 1'b0}; // Divide with zero extension
            R = temp[3:0];
            OF = temp[4];
        end
        else begin
            R = 4'b0000;
            OF = 1'b1;
        end
    end
end

endmodule