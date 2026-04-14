module top_module(
    input signed [15:0] A,
    input signed [15:0] B,
    input [1:0] op,
    output reg signed [15:0] result
);always @(*)
begin
    case(op)
        2'b00: result = A + B; // Addition
        2'b01: result = A - B; // Subtraction
        2'b10: result = A * B; // Multiplication
        2'b11: begin // Division
            if(B == 0) // Division by zero
                result = 16'hFFFF; // Maximum possible 16-bit number
            else
                result = A / B;
        end
    endcase
end

endmodule