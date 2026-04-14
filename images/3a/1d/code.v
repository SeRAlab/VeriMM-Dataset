module temperature_sensor_controller(
    input clk,
    input reset,
    input [4:0] temperature,
    output reg alert,
    output reg [4:0] last_temperature
);
    parameter THRESHOLD = 5'd25;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            last_temperature <= 5'b00000;
            alert <= 0;
        end else begin
            last_temperature <= temperature;
            if (temperature > THRESHOLD) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule