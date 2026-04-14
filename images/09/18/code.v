module encoder_8_to_3 (
    input [7:0] I, 
    output reg [2:0] Y
);
    always @(*) begin
        case (I)
            8'b0000_0001: Y = 3'b000;
            8'b0000_0010: Y = 3'b001;
            8'b0000_0100: Y = 3'b010;
            8'b0000_1000: Y = 3'b011;
            8'b0001_0000: Y = 3'b100;
            8'b0010_0000: Y = 3'b101;
            8'b0100_0000: Y = 3'b110;
            8'b1000_0000: Y = 3'b111;
            default: Y = 3'b111; // Invalid state
        endcase
    end
endmodule