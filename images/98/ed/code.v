module top_module(
    input [3:0] a,
    input [3:0] b,
    input [1:0] sel,
    output reg [3:0] out
);

    // Always block to determine the ALU operation
    always @(*) begin
        case(sel)
            2'b00: out = a + b; // Addition
            2'b01: out = a - b; // Subtraction
            2'b10: out = a & b; // AND
            2'b11: out = a | b; // OR
            default: out = 4'b0; // Default case
        endcase
    end

endmodule