module mux_2to1_8bit(IN0, IN1, SEL, OUT);
input [7:0] IN0, IN1;
input SEL;
output reg [7:0] OUT;

always @(*) begin
    if (SEL)
        OUT = IN1;
    else
        OUT = IN0;
end

endmodule