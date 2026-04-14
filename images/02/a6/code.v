module gaussian_blur (
    input [7:0] I1, I2, I3,
    input [7:0] I4, I5, I6,
    input [7:0] I7, I8, I9,
    output reg [7:0] O
);
    always @(*) begin
        O = (I1 + 2*I2 + I3 + 2*I4 + 4*I5 + 2*I6 + I7 + 2*I8 + I9) / 16;
    end
endmodule