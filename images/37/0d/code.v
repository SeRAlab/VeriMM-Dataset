module decoder_2to4 (
    input [1:0] A,     // 2-bit input
    output reg [3:0] D // 4-bit output
);
    always @(*) begin
        case (A)
            2'b00: D = 4'b0001; // D0 is high
            2'b01: D = 4'b0010; // D1 is high
            2'b10: D = 4'b0100; // D2 is high
            2'b11: D = 4'b1000; // D3 is high
            default: D = 4'b0000; // Default case
        endcase
    end
endmodule