module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] result
);always @(*) begin
        case (op)
            2'b00: result = A + B; // Addition
            2'b01: result = A - B; // Subtraction
            2'b10: result = A * B; // Multiplication
            2'b11: begin            // Division
                if (B == 0) begin
                    result = 8'b00000000; // Divide by zero error
                end else begin
                    result = A / B;
                end
            end
            default: result = 8'b00000000; // Error
        endcase
    end

endmodule