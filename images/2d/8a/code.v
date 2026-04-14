module temp_sensor (
    input [9:0] temp_in, // 10-bit input for temperature
    output reg [4:0] temp_out // 5-bit output for category
);
    always @(*) begin
        if (temp_in < 10'b0000000000) // Below 0 °C
            temp_out = 5'b00000;
        else if (temp_in <= 10'b0000101010) // 0 °C to 10 °C
            temp_out = 5'b00001;
        else if (temp_in <= 10'b0001010100) // 11 °C to 20 °C
            temp_out = 5'b00010;
        else if (temp_in <= 10'b0001110000) // 21 °C to 30 °C
            temp_out = 5'b00011;
        else // Above 30 °C
            temp_out = 5'b00100;
    end
endmodule