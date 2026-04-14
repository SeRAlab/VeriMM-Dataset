module priority_encoder (
    input [3:0] I,
    output reg [1:0] Y,
    output reg valid
);
    always @(*) begin
        case (I)
            4'b0000: begin Y = 2'b00; valid = 0; end
            4'b0001: begin Y = 2'b00; valid = 1; end
            4'b0010: begin Y = 2'b01; valid = 1; end
            4'b0011: begin Y = 2'b01; valid = 1; end
            4'b0100: begin Y = 2'b10; valid = 1; end
            4'b0101: begin Y = 2'b10; valid = 1; end
            4'b0110: begin Y = 2'b10; valid = 1; end
            4'b0111: begin Y = 2'b10; valid = 1; end
            4'b1000: begin Y = 2'b11; valid = 1; end
            4'b1001: begin Y = 2'b11; valid = 1; end
            4'b1010: begin Y = 2'b11; valid = 1; end
            4'b1011: begin Y = 2'b11; valid = 1; end
            4'b1100: begin Y = 2'b11; valid = 1; end
            4'b1101: begin Y = 2'b11; valid = 1; end
            4'b1110: begin Y = 2'b11; valid = 1; end
            4'b1111: begin Y = 2'b11; valid = 1; end
            default: begin Y = 2'b00; valid = 0; end
        endcase
    end
endmodule