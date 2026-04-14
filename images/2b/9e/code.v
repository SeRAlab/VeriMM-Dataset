module temperature_sensor_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg alarm,
    output reg active
);
    parameter THRESHOLD = 8'd75;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alarm <= 0;
            active <= 0;
        end else begin
            active <= 1;
            if (temperature > THRESHOLD) begin
                alarm <= 1;
            end else begin
                alarm <= 0;
            end
        end
    end
endmodule