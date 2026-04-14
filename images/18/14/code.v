module priority_encoder (
    input [15:0] I,
    output reg [3:0] O
);
    always @(*) begin
        casez (I)
            16'b1??????????????: O = 4'd15; // I15 is high
            16'b01?????????????: O = 4'd14; // I14 is high
            16'b001????????????: O = 4'd13; // I13 is high
            16'b0001???????????: O = 4'd12; // I12 is high
            16'b00001??????????: O = 4'd11; // I11 is high
            16'b000001?????????: O = 4'd10; // I10 is high
            16'b0000001???????: O = 4'd9;  // I9 is high
            16'b00000001??????: O = 4'd8;  // I8 is high
            16'b000000001?????: O = 4'd7;  // I7 is high
            16'b0000000001????: O = 4'd6;  // I6 is high
            16'b00000000001???: O = 4'd5;  // I5 is high
            16'b000000000001??: O = 4'd4;  // I4 is high
            16'b0000000000001?: O = 4'd3;  // I3 is high
            16'b00000000000001: O = 4'd2;  // I2 is high
            16'b00000000000000: O = 4'd1;  // I1 is high
            default: O = 4'bXXXX;          // No inputs are high
        endcase
    end
endmodule