module temperature_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    input wire [7:0] threshold,
    output reg alert
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else begin
            if (temperature > threshold) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule