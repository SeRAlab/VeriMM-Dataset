module encoder4to2(
    input [3:0] in,
    output reg [1:0] out
);

always @(*) begin
    case (in)
        4'b0000: out = 2'b00; // No active input
        4'b0001: out = 2'b00; // Input 0
        4'b0010: out = 2'b01; // Input 1
        4'b0100: out = 2'b10; // Input 2
        4'b1000: out = 2'b11; // Input 3
        default: out = 2'b00; // Input not defined
    endcase
end

endmodule