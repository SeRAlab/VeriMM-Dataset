module temperature_sensor(
    input wire clk,
    input wire reset,
    input wire [3:0] temperature,
    output reg alert
);

parameter THRESHOLD = 4'b1000; // Threshold value of 8

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alert <= 1'b0;
    end else begin
        if (temperature > THRESHOLD) begin
            alert <= 1'b1;
        end else begin
            alert <= 1'b0;
        end
    end
end

endmodule