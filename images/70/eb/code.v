module top_module(
    input [3:0] in,
    output reg [3:0] out  // Change wire to reg since we are assigning in an always block
);always @* begin
    case (in)
        4'b0000: out = 4'b0000;
        4'b0001, 4'b0010: out = 4'b0001;
        4'b0011, 4'b0100: out = 4'b0010;
        4'b0101, 4'b0110: out = 4'b0011;
        4'b0111, 4'b1000: out = 4'b0100;
        4'b1001, 4'b1010: out = 4'b0101;
        4'b1011, 4'b1100: out = 4'b0110;
        4'b1101, 4'b1110: out = 4'b0111;
        4'b1111: out = 4'b1000;
        default: out = 4'b0000;  // Optional default case to avoid latches
    endcase
end

endmodule