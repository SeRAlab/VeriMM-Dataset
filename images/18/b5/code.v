module temperature_sensor(
    input [4:0] temperature,
    output reg high_temp
);
    always @(*) begin
        if (temperature > 5'd25) begin
            high_temp = 1'b1; // Temperature is too high
        end else begin
            high_temp = 1'b0; // Temperature is within limits
        end
    end
endmodule