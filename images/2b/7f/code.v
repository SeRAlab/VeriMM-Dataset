module encoder_16_to_4 (
    input [15:0] I,
    output reg [3:0] Y,
    output reg V
);
    always @(*) begin
        V = 1'b0; // Default valid output
        casez (I)
            16'b1??????????????? : begin Y = 4'b1111; V = 1'b1; end // I15
            16'b01?????????????? : begin Y = 4'b1110; V = 1'b1; end // I14
            16'b001????????????? : begin Y = 4'b1101; V = 1'b1; end // I13
            16'b0001???????????? : begin Y = 4'b1100; V = 1'b1; end // I12
            16'b00001??????????? : begin Y = 4'b1011; V = 1'b1; end // I11
            16'b000001?????????? : begin Y = 4'b1010; V = 1'b1; end // I10
            16'b0000001????????? : begin Y = 4'b1001; V = 1'b1; end // I9
            16'b00000001??????? : begin Y = 4'b1000; V = 1'b1; end // I8
            16'b000000001?????? : begin Y = 4'b0111; V = 1'b1; end // I7
            16'b0000000001????? : begin Y = 4'b0110; V = 1'b1; end // I6
            16'b00000000001???? : begin Y = 4'b0101; V = 1'b1; end // I5
            16'b000000000001??? : begin Y = 4'b0100; V = 1'b1; end // I4
            16'b0000000000001?? : begin Y = 4'b0011; V = 1'b1; end // I3
            16'b00000000000001? : begin Y = 4'b0010; V = 1'b1; end // I2
            16'b000000000000001  : begin Y = 4'b0001; V = 1'b1; end // I1
            16'b0000000000000001 : begin Y = 4'b0000; V = 1'b1; end // I0
            default: begin Y = 4'b0000; V = 1'b0; end // No input active
        endcase
    end
endmodule