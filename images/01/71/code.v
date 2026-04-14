module encoder_16_to_4 (
    input [15:0] data_in,
    output reg [3:0] data_out
);
    always @(*) begin
        casez (data_in)
            16'b1??????????????? : data_out = 4'b0000; // input 0
            16'b01?????????????? : data_out = 4'b0001; // input 1
            16'b001????????????? : data_out = 4'b0010; // input 2
            16'b0001???????????? : data_out = 4'b0011; // input 3
            16'b00001??????????? : data_out = 4'b0100; // input 4
            16'b000001?????????? : data_out = 4'b0101; // input 5
            16'b0000001????????? : data_out = 4'b0110; // input 6
            16'b00000001???????? : data_out = 4'b0111; // input 7
            16'b000000001??????? : data_out = 4'b1000; // input 8
            16'b0000000001?????? : data_out = 4'b1001; // input 9
            16'b00000000001????? : data_out = 4'b1010; // input 10
            16'b000000000001???? : data_out = 4'b1011; // input 11
            16'b0000000000001??? : data_out = 4'b1100; // input 12
            16'b00000000000001?? : data_out = 4'b1101; // input 13
            16'b000000000000001? : data_out = 4'b1110; // input 14
            16'b0000000000000001 : data_out = 4'b1111; // input 15
            default: data_out = 4'b1111; // invalid
        endcase
    end
endmodule