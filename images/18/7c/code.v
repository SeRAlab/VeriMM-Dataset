module temperature_sensor(
    input wire clk,
    input wire [3:0] temp,
    output reg alarm
);

    always @(posedge clk) begin
        if (temp > 4'd10) begin
            alarm <= 1'b1; // Set alarm high if temperature exceeds 10
        end else begin
            alarm <= 1'b0; // Reset alarm if temperature is 10 or lower
        end
    end
endmodule