module priority_encoder (
    input [7:0] I,
    input EN,
    output reg [2:0] Y
);

always @(*) begin
    if (!EN) begin
        Y = 3'b000; // Output is 000 when enable is low
    end else begin
        casez (I)
            8'b1???????: Y = 3'b111; // I7 is active
            8'b01??????: Y = 3'b110; // I6 is active
            8'b001?????: Y = 3'b101; // I5 is active
            8'b0001????: Y = 3'b100; // I4 is active
            8'b00001???: Y = 3'b011; // I3 is active
            8'b000001??: Y = 3'b010; // I2 is active
            8'b0000001?: Y = 3'b001; // I1 is active
            8'b00000001: Y = 3'b000; // I0 is active
            default:     Y = 3'b000; // No inputs are active
        endcase
    end
end

endmodule