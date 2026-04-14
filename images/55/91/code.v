module encoder_4to2(
    input [3:0] y,    // 4-bit one-hot input.
    output reg [1:0] a // 2-bit binary output.
);

// Encoder logic
always @(*) begin
    case (y)
        4'b0001: a = 2'b00;
        4'b0010: a = 2'b01;
        4'b0100: a = 2'b10;
        4'b1000: a = 2'b11;
        default: a = 2'b00; // Default case for invalid input
    endcase
end

endmodule