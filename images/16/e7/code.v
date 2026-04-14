module priority_encoder_16to4 (
    input [15:0] in,
    output reg [3:0] out
);
    always @(*) begin
        casez(in)
            16'b1??????????????? : out = 4'd0; // Input 0 is high
            16'b01?????????????? : out = 4'd1; // Input 1 is high
            16'b001????????????? : out = 4'd2; // Input 2 is high
            16'b0001???????????? : out = 4'd3; // Input 3 is high
            16'b00001??????????? : out = 4'd4; // Input 4 is high
            16'b000001?????????? : out = 4'd5; // Input 5 is high
            16'b0000001????????? : out = 4'd6; // Input 6 is high
            16'b00000001??????? : out = 4'd7; // Input 7 is high
            16'b000000001?????? : out = 4'd8; // Input 8 is high
            16'b0000000001????? : out = 4'd9; // Input 9 is high
            16'b00000000001???? : out = 4'd10; // Input 10 is high
            16'b000000000001??? : out = 4'd11; // Input 11 is high
            16'b0000000000001?? : out = 4'd12; // Input 12 is high
            16'b00000000000001? : out = 4'd13; // Input 13 is high
            16'b000000000000001 : out = 4'd14; // Input 14 is high
            default: out = 4'b1111; // No inputs are high (invalid)
        endcase
    end
endmodule