module priority_encoder (
    input [3:0] I, // 4 inputs
    output reg [1:0] Y, // 2 outputs
    output reg valid // indicates if any input is high
);
    always @(*) begin
        casez(I)
            4'b1???: begin Y = 2'b11; valid = 1; end // I3 is high
            4'b01??: begin Y = 2'b10; valid = 1; end // I2 is high
            4'b001?: begin Y = 2'b01; valid = 1; end // I1 is high
            4'b0001: begin Y = 2'b00; valid = 1; end // I0 is high
            default: begin Y = 2'b00; valid = 0; end // no input is high
        endcase
    end
endmodule