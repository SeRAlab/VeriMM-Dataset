module temperature_sensor(
    input clk,
    input reset,
    input [9:0] temperature,
    output reg alert
);
    parameter THRESHOLD = 10'b0000011001; // 25 degrees Celsius
    parameter ALERT_DURATION = 10000000; // Duration for the alert
    
    reg [25:0] counter;
    reg alert_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
            counter <= 0;
            alert_state <= 0;
        end else begin
            if (temperature > THRESHOLD) begin
                alert_state <= 1;
                counter <= 0;
            end else if (alert_state) begin
                counter <= counter + 1;
                if (counter >= ALERT_DURATION) begin
                    alert_state <= 0;
                end
            end
            alert <= alert_state;
        end
    end
endmodule