module top_module(
    input [3:0] binary_in,
    output reg [3:0] gray_out  // Fixed to 4 bits for gray code output
);always @(*) begin
        case(binary_in)
            4'b0000: gray_out = 4'b0000;  // Correct required size
            4'b0001: gray_out = 4'b0001;  // Correct required size
            4'b0010: gray_out = 4'b0011;  // Correct required size
            4'b0011: gray_out = 4'b0010;  // Correct required size
            4'b0100: gray_out = 4'b0110;  // Correct required size
            4'b0101: gray_out = 4'b0111;  // Correct required size
            4'b0110: gray_out = 4'b0101;  // Correct required size
            4'b0111: gray_out = 4'b0100;  // Correct required size
            4'b1000: gray_out = 4'b1100;  // Correct required size
            4'b1001: gray_out = 4'b1101;  // Correct required size
            4'b1010: gray_out = 4'b1011;  // Correct required size
            4'b1011: gray_out = 4'b1010;  // Correct required size
            4'b1100: gray_out = 4'b1110;  // Correct required size
            4'b1101: gray_out = 4'b1111;  // Correct required size
            4'b1110: gray_out = 4'b1101;  // Correct required size
            4'b1111: gray_out = 4'b1100;  // Correct required size
            default: gray_out = 4'b0000;   // Default case to handle unexpected values
        endcase
    end

endmodule