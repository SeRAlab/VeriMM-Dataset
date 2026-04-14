module priority_encoder_8bit(
    input wire [7:0] one_hot,
    output reg [2:0] binary_out
    );

always @(*) begin
    case (one_hot)
        8'b10000000: binary_out = 3'b111;
        8'b01000000: binary_out = 3'b110;
        8'b00100000: binary_out = 3'b101;
        8'b00010000: binary_out = 3'b100;
        8'b00001000: binary_out = 3'b011;
        8'b00000100: binary_out = 3'b010;
        8'b00000010: binary_out = 3'b001;
        8'b00000001: binary_out = 3'b000;
        default: binary_out = 3'b000;
    endcase
end

endmodule