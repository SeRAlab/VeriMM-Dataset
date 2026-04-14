module temperature_sensor (
    input [4:0] temp, // 5-bit input for temperature
    output reg [2:0] category // 3-bit output category
);
    always @(*) begin
        if (temp <= 5'b01111) // 0-15°C
            category = 3'b000; // cold
        else if (temp <= 5'b11000) // 16-25°C
            category = 3'b001; // warm
        else if (temp <= 5'b100011) // 26-35°C
            category = 3'b010; // hot
        else if (temp <= 5'b101101) // 36-45°C
            category = 3'b011; // very hot
        else // 46°C and above
            category = 3'b100; // extreme hot
    end
endmodule