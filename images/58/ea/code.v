module priority_encoder_8bit(
    input wire [7:0] data_in,
    output reg [2:0] binary_out
    );

always @(*) begin
    casez (data_in)
        8'b1???????: binary_out = 3'b111;
        8'b01??????: binary_out = 3'b110;
        8'b001?????: binary_out = 3'b101;
        8'b0001????: binary_out = 3'b100;
        8'b00001???: binary_out = 3'b011;
        8'b000001??: binary_out = 3'b010;
        8'b0000001?: binary_out = 3'b001;
        8'b00000001: binary_out = 3'b000;
        default: binary_out = 3'b000;
    endcase
end

endmodule