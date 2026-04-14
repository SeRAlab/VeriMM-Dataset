module top_module(
    input [3:0] ABCD,
    output reg [1:0] XY
);always @* begin
    case (ABCD)
        4'b0001: XY = 2'b00; // A has highest priority
        4'b0010: XY = 2'b01; // B has highest priority
        4'b0100: XY = 2'b10; // C has highest priority
        4'b1000: XY = 2'b11; // D has highest priority
        4'b0011, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1100: XY = 2'b01; // Second highest priority
        default: XY = 2'b00; // All inputs are 0
    endcase
end

endmodule