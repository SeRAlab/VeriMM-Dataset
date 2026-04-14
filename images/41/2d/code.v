module top_module(
    input signed [31:0] a,
    input signed [31:0] b,
    input [1:0] op,
    output reg signed [31:0] c  // Change output to reg type
);// Declare internal signals
reg signed [31:0] sum;
reg signed [31:0] diff;
reg signed [31:0] prod;
reg signed [31:0] quotient;

// Perform arithmetic operations
always @* begin
    sum = a + b;
    diff = a - b;
    prod = a * b;
    quotient = a / b;
end

// Select output based on op
always @* begin
    case (op)
        2'b00: c = sum;
        2'b01: c = diff;
        2'b10: c = prod;
        2'b11: c = quotient;
        default: c = 0; // Added default case for safety
    endcase
end

endmodule