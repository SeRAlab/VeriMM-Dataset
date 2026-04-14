module priority_encoder_8bit(
    input [7:0] din,
    
    output reg [2:0] dout,
    output reg valid
);
    always @(*) begin
        valid = 1'b1;
        casez(din)
            8'b1???????: dout = 3'b111;
            8'b01??????: dout = 3'b110;
            8'b001?????: dout = 3'b101;
            8'b0001????: dout = 3'b100;
            8'b00001???: dout = 3'b011;
            8'b000001??: dout = 3'b010;
            8'b0000001?: dout = 3'b001;
            8'b00000001: dout = 3'b000;
            default: begin
                dout = 3'b000;
                valid = 1'b0;
            end
        endcase
    end
endmodule