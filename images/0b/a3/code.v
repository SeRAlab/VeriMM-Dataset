module temperature_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [9:0] temperature,
    output reg alarm
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alarm <= 0;
        end else begin
            if (temperature > 10'd75) begin
                alarm <= 1;
            end else begin
                alarm <= 0;
            end
        end
    end
endmodule