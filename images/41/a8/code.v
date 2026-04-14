module mux_4to1(I0, I1, I2, I3, SEL, Y);
input I0, I1, I2, I3;
input [1:0] SEL;
output Y;
reg Y;

always @(I0, I1, I2, I3, SEL) begin
    case (SEL)
        2'b00: Y = I0;
        2'b01: Y = I1;
        2'b10: Y = I2;
        2'b11: Y = I3;
        default: Y = 1'b0; // default case
    endcase
end

endmodule