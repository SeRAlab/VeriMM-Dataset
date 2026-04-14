module priority_encoder (
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);
    always @(*) begin
        casez (in)
            4'b1??? : begin out = 2'b11; valid = 1; end // I3 is active
            4'b01?? : begin out = 2'b10; valid = 1; end // I2 is active
            4'b001? : begin out = 2'b01; valid = 1; end // I1 is active
            4'b0001 : begin out = 2'b00; valid = 1; end // I0 is active
            default : begin out = 2'b00; valid = 0; end // No input is active
        endcase
    end
endmodule