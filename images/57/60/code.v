module priority_encoder_4bit (
    input [3:0] din,
    output reg [1:0] dout
);

always @(*) begin
    casez(din)
        4'b1???: dout = 2'b11;
        4'b01??: dout = 2'b10;
        4'b001?: dout = 2'b01;
        4'b0001: dout = 2'b00;
        default: dout = 2'b00;
    endcase
end

endmodule