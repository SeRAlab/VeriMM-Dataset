module top_module(
    input [3:0] bin_in,
    output reg [3:0] dec_out   // Change from 3 bits to 4 bits to accommodate outputs.
);always @(*) begin
    case(bin_in)
        4'b0000: dec_out = 4'b0000;
        4'b0001: dec_out = 4'b0001;
        4'b0010: dec_out = 4'b0010;
        4'b0011: dec_out = 4'b0011;
        4'b0100: dec_out = 4'b0100;
        4'b0101: dec_out = 4'b0101;
        4'b0110: dec_out = 4'b0110;
        4'b0111: dec_out = 4'b0111;
        4'b1000: dec_out = 4'b1000;
        4'b1001: dec_out = 4'b1001;
        4'b1010: dec_out = 4'b1010;
        4'b1011: dec_out = 4'b1011;
        4'b1100: dec_out = 4'b1100;
        4'b1101: dec_out = 4'b1101;
        4'b1110: dec_out = 4'b1110;
        4'b1111: dec_out = 4'b1111;
        default: dec_out = 4'b0000; // Default case to avoid latches
    endcase
end

endmodule