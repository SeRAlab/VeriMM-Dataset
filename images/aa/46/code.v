module top_module(a, b, op, result);input [7:0] a;
    input [7:0] b;
    input [1:0] op;
    output reg [7:0] result; // Change: Declare result as reg

    reg [7:0] temp_result;
    reg [7:0] error_code;

    always @(*) begin
        temp_result = 8'h00; // Initialize temp_result
        error_code = 8'hFF; // Initialize error_code to a default value
        case(op)
            2'b00: temp_result = a + b; // Addition
            2'b01: temp_result = a - b; // Subtraction
            2'b10: temp_result = a * b; // Multiplication
            2'b11: begin // Division
                if(b == 0) begin
                    error_code = 8'h00; // Division by zero error
                end else begin
                    temp_result = a / b;
                end
            end
        endcase

        // Check for overflow (this check assumes unsigned operations only)
        if(temp_result > 8'hFF || temp_result < 8'h00) begin
            error_code = 8'hFF; // Overflow error
        end 
        
        // Assign result based on error_code
        if(error_code == 8'h00) begin
            result = 8'h00; // Error: Division by zero
        end else if(error_code == 8'hFF) begin
            result = 8'hFF; // Error: Overflow
        end else begin
            result = temp_result; // Valid result
        end
    end
endmodule