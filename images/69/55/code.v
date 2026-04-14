module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input [1:0] op,
    output reg signed [15:0] result // Changed from wire to reg
);reg signed [15:0] temp_result;

always @(*) begin
    case (op)
        2'b00: temp_result = a + b; // Addition
        2'b01: temp_result = a - b; // Subtraction
        2'b10: temp_result = a * b; // Multiplication
        2'b11: temp_result = a / b; // Division
        default: temp_result = 0; // Default case to handle unexpected op
    endcase
end

always @(*) begin
    // Handle overflow and underflow conditions for addition and subtraction
    if (op == 2'b00) begin // Addition
        if (temp_result > 32767) result = 32767;
        else if (temp_result < -32768) result = -32768;
        else result = temp_result;
    end
    else if (op == 2'b01) begin // Subtraction
        if (temp_result > 32767) result = 32767;
        else if (temp_result < -32768) result = -32768;
        else result = temp_result;
    end
    else begin // Multiplication and division
        if (temp_result > 32767) result = 32767;
        else if (temp_result < -32768) result = -32768;
        else result = temp_result[15:0]; // Keep as 16-bit signed integer
    end
end

endmodule