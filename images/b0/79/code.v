module priority_encoder_4bit(IN, OUT, VALID);
input [3:0] IN;
output reg [1:0] OUT;
output reg VALID;

always @(*) begin
    casez (IN)
        4'b1???: begin OUT = 2'b11; VALID = 1; end
        4'b01??: begin OUT = 2'b10; VALID = 1; end
        4'b001?: begin OUT = 2'b01; VALID = 1; end
        4'b0001: begin OUT = 2'b00; VALID = 1; end
        default: begin OUT = 2'b00; VALID = 0; end
    endcase
end

endmodule