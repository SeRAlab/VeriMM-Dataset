module temperature_sensor(
    input [3:0] temperature,
    output reg [2:0] temperature_level
);
    always @(*) begin
        if (temperature <= 4'd5) begin
            temperature_level = 3'b000; // Low
        end else if (temperature <= 4'd10) begin
            temperature_level = 3'b001; // Moderate
        end else begin
            temperature_level = 3'b010; // High
        end
    end
endmodule