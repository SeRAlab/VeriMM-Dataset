module priority_encoder_8bit(
    input [7:0] in,  // 8-bit input signal.

    output reg [2:0] out // 3-bit output representing the position of the highest-order '1' bit.
);

//------------------------------------------------
// Priority encoder operation
always @(*) begin
    casez (in)
        8'b1???????: out = 3'b111;
        8'b01??????: out = 3'b110;
        8'b001?????: out = 3'b101;
        8'b0001????: out = 3'b100;
        8'b00001???: out = 3'b011;
        8'b000001??: out = 3'b010;
        8'b0000001?: out = 3'b001;
        8'b00000001: out = 3'b000;
        default:     out = 3'b000; // Default case when input is all zeroes
    endcase
end

endmodule