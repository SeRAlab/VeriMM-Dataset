module top_module(
    input A,
    input B,
    input C,
    output reg [7:0] Y
);always @*
begin
    case ({A,B,C})
        3'b000: Y = 8'b11111110; // Y[0] is active low
        3'b001: Y = 8'b11111101; // Y[1] is active low
        3'b010: Y = 8'b11111011; // Y[2] is active low
        3'b011: Y = 8'b11110111; // Y[3] is active low
        3'b100: Y = 8'b11101111; // Y[4] is active low
        3'b101: Y = 8'b11011111; // Y[5] is active low
        3'b110: Y = 8'b10111111; // Y[6] is active low
        3'b111: Y = 8'b01111111; // Y[7] is active low
        default: Y = 8'b11111111; // all outputs are high
    endcase
end

endmodule