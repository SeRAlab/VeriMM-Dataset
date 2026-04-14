module temp_sensor_controller(
    input clk,
    input reset,
    input [6:0] temperature,
    output reg alert
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else begin
            if (temperature > 100) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule