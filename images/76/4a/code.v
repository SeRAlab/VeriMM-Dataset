module top_module(
    input [1:0] rot,
    output reg [15:0] block
);always @(*) begin
    case (rot)
        2'b00: block = 16'b0100010011000000; // Example output
        2'b01: block = 16'b0000111010000000; // Example output
        2'b10: block = 16'b1100010001000000; // Example output
        2'b11: block = 16'b0010111000000000; // Example output
        default: block = 16'b0100010011000000; // Default case output
    endcase
end

endmodule