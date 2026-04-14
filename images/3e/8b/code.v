module priority_encoder (
    input [7:0] I,
    output reg [2:0] Y
);
    always @(*) begin
        casez (I)
            8'b1xxxxxxx: Y = 3'b111; // I7
            8'b01xxxxxx: Y = 3'b110; // I6
            8'b001xxxxx: Y = 3'b101; // I5
            8'b0001xxxx: Y = 3'b100; // I4
            8'b00001xxx: Y = 3'b011; // I3
            8'b000001xx: Y = 3'b010; // I2
            8'b0000001x: Y = 3'b001; // I1
            8'b00000001: Y = 3'b000; // I0
            default:     Y = 3'b000; // No inputs
        endcase
    end
endmodule