module encoder_8_to_3 (
    input [7:0] I,
    output reg [2:0] Y,
    output reg valid
);
    always @(*) begin
        valid = 1'b0; // Default to invalid
        casez (I)
            8'b1??????? : begin Y = 3'b000; valid = 1'b1; end // I0
            8'b01?????? : begin Y = 3'b001; valid = 1'b1; end // I1
            8'b001????? : begin Y = 3'b010; valid = 1'b1; end // I2
            8'b0001???? : begin Y = 3'b011; valid = 1'b1; end // I3
            8'b00001??? : begin Y = 3'b100; valid = 1'b1; end // I4
            8'b000001?? : begin Y = 3'b101; valid = 1'b1; end // I5
            8'b0000001? : begin Y = 3'b110; valid = 1'b1; end // I6
            8'b00000001 : begin Y = 3'b111; valid = 1'b1; end // I7
            default: begin Y = 3'b000; valid = 1'b0; end // No valid input
        endcase
    end
endmodule