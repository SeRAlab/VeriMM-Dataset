module priority_encoder(
    input [31:0] data_in,
    
    output reg [4:0] position
);

always @(*) begin
    position = 5'b00000;
    if (data_in[31]) position = 5'b11111;
    else if (data_in[30]) position = 5'b11110;
    else if (data_in[29]) position = 5'b11101;
    else if (data_in[28]) position = 5'b11100;
    else if (data_in[27]) position = 5'b11011;
    else if (data_in[26]) position = 5'b11010;
    else if (data_in[25]) position = 5'b11001;
    else if (data_in[24]) position = 5'b11000;
    else if (data_in[23]) position = 5'b10111;
    else if (data_in[22]) position = 5'b10110;
    else if (data_in[21]) position = 5'b10101;
    else if (data_in[20]) position = 5'b10100;
    else if (data_in[19]) position = 5'b10011;
    else if (data_in[18]) position = 5'b10010;
    else if (data_in[17]) position = 5'b10001;
    else if (data_in[16]) position = 5'b10000;
    else if (data_in[15]) position = 5'b01111;
    else if (data_in[14]) position = 5'b01110;
    else if (data_in[13]) position = 5'b01101;
    else if (data_in[12]) position = 5'b01100;
    else if (data_in[11]) position = 5'b01011;
    else if (data_in[10]) position = 5'b01010;
    else if (data_in[9]) position = 5'b01001;
    else if (data_in[8]) position = 5'b01000;
    else if (data_in[7]) position = 5'b00111;
    else if (data_in[6]) position = 5'b00110;
    else if (data_in[5]) position = 5'b00101;
    else if (data_in[4]) position = 5'b00100;
    else if (data_in[3]) position = 5'b00011;
    else if (data_in[2]) position = 5'b00010;
    else if (data_in[1]) position = 5'b00001;
    else if (data_in[0]) position = 5'b00000;
end

endmodule