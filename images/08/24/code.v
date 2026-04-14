module encoder_4_to_2 (
    input wire [3:0] in,
    output reg [1:0] out
);

always @(*) begin
    case (in)
        4'b0000: out = 2'b00; // No input active
        4'b0001: out = 2'b00; // Input 0 active
        4'b0010: out = 2'b01; // Input 1 active
        4'b0100: out = 2'b10; // Input 2 active
        4'b1000: out = 2'b11; // Input 3 active
        4'b0011: out = 2'b01; // Input 1 or 0 active, highest is 1
        4'b1100: out = 2'b11; // Input 3 or 2 active, highest is 3
        4'b0110: out = 2'b10; // Input 2 or 1 active, highest is 2
        4'b1110: out = 2'b11; // Input 3 or 2 or 1 active, highest is 3
        4'b1111: out = 2'b11; // All inputs active, highest is 3
        default: out = 2'b00; // Default case
    endcase
end

endmodule