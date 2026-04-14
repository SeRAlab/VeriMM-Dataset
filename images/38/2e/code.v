module priority_encoder (
    input [3:0] I,
    output reg [1:0] Y,
    output reg valid
);

always @(*) begin
    casez (I)
        4'b1???: begin
            Y = 2'b11; valid = 1'b1; // I3 is active
        end
        4'b01??: begin
            Y = 2'b10; valid = 1'b1; // I2 is active
        end
        4'b001?: begin
            Y = 2'b01; valid = 1'b1; // I1 is active
        end
        4'b0001: begin
            Y = 2'b00; valid = 1'b1; // I0 is active
        end
        default: begin
            Y = 2'b00; valid = 1'b0; // No input is active
        end
    endcase
end

endmodule