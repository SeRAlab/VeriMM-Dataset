module top_module(
    input [7:0] op1,
    input [7:0] op2,
    output reg [7:0] result,  // Changed to reg
    output reg carry,          // Changed to reg
    output reg overflow,       // Changed to reg
    output reg error           // Changed to reg
);reg [8:0] sum;
    reg [8:0] diff;
    reg [15:0] prod;
    reg [7:0] quotient;
    reg [7:0] remainder;
    
    // Addition
    always @* begin
        sum = op1 + op2;
        result = sum[7:0];
        carry = sum[8];
        overflow = (op1[7] == op2[7]) && (sum[7] != op1[7]);
        error = 0;
    end

    // Subtraction
    always @* begin
        diff = op1 - op2;
        result = diff[7:0];
        carry = ~diff[8];
        overflow = (op1[7] != op2[7]) && (diff[7] != op1[7]);
        error = 0;
    end

    // Multiplication
    always @* begin
        prod = op1 * op2;
        result = prod[7:0];
        carry = prod[15];
        overflow = (prod[15:8] != 8'b0) || ((prod[7] == 1) && (op1[7] != op2[7]));
        error = 0;
    end

    // Division
    always @* begin
        if (op2 == 8'b0) begin
            error = 1;
            result = 8'b0;
            carry = 0;
            overflow = 0;
        end else begin
            quotient = op1 / op2;
            remainder = op1 % op2;
            result = quotient;
            carry = remainder[7];
            overflow = (quotient > 8'b11111111);
            error = 0;
        end
    end

endmodule