module temperature_sensor(
    input wire clk,
    input wire reset,
    input wire [3:0] temperature,
    output reg alert
);
    parameter THRESHOLD = 4'b1010; // Threshold set to 10 degrees

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 1'b0;
        end else begin
            if (temperature > THRESHOLD) begin
                alert <= 1'b1; // Activate alert if temperature exceeds threshold
            end else begin
                alert <= 1'b0; // Deactivate alert otherwise
            end
        end
    end
endmodule