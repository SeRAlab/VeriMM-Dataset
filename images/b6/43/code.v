module top_module(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] result,
    output reg overflow,
    output reg underflow
);always @(posedge clk) begin
        case(op)
            2'b00: begin // Addition
                result <= A + B;
                overflow <= ((A[7] == B[7]) && (result[7] != A[7]));
                underflow <= 0;
            end
            2'b01: begin // Subtraction
                result <= A - B;
                overflow <= ((A[7] != B[7]) && (result[7] != A[7]));
                underflow <= ((A[7] == 1) && (B[7] == 0) && (result[7] == 0));
            end
            2'b10: begin // Multiplication
                result <= A * B;
                overflow <= (result[15:8] != 0);
                underflow <= 0;
            end
            2'b11: begin // Division
                if (B == 8'b0) begin
                    result <= 8'b0;
                    overflow <= 0;
                    underflow <= 1;
                end else begin
                    result <= A / B;
                    overflow <= 0;
                    underflow <= 0;
                end
            end
            default: begin
                result <= 8'b0;
                overflow <= 0;
                underflow <= 0;
            end
        endcase
    end
endmodule