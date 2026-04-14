module priority_encoder (
    input [7:0] D,
    output reg [2:0] Y
);
    always @(*) begin
        casez (D)
            8'b1???????: Y = 3'b111; // D7
            8'b01??????: Y = 3'b110; // D6
            8'b001?????: Y = 3'b101; // D5
            8'b0001????: Y = 3'b100; // D4
            8'b00001???: Y = 3'b011; // D3
            8'b000001??: Y = 3'b010; // D2
            8'b0000001?: Y = 3'b001; // D1
            8'b00000001: Y = 3'b000; // D0
            default:     Y = 3'bxxx;  // No input active
        endcase
    end
endmodule