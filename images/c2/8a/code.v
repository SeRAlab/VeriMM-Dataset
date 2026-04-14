module mux4to1(I0, I1, I2, I3, S, F);
    input I0, I1, I2, I3;
    input [1:0] S;
    output F;

    reg F;

    always @(*) begin
        case (S)
            2'b00: F = I0;
            2'b01: F = I1;
            2'b10: F = I2;
            2'b11: F = I3;
        endcase
    end
endmodule