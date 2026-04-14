module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] SEL,
    output reg [3:0] Q // Changed output to reg to use in always block
);wire [3:0] highest_priority_input;

// Priority encoder
assign highest_priority_input = (D > C) ? 4'b1100 : 
                                 (C > B) ? 4'b1000 : 
                                 (B > A) ? 4'b0100 : 
                                 4'b0010; // Updated to a single assign statement for clarity

// Multiplexer
always @(*) begin
    case (SEL)
        2'b00: Q = A;
        2'b01: Q = B;
        2'b10: Q = C;
        2'b11: Q = D;
        default: Q = 4'b0000; // Added a default case
    endcase
end

// Output the highest priority input if multiple inputs are high
always @(*) begin // Use another always block for the output condition
    if (A == highest_priority_input) 
        Q = A;
    else if (B == highest_priority_input) 
        Q = B;
    else if (C == highest_priority_input) 
        Q = C;
    else if (D == highest_priority_input) 
        Q = D;
    else 
        Q = 4'b0000;
end

endmodule