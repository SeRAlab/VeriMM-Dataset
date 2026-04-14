module temperature_shutdown (
    input wire clk,
    input wire reset,
    input wire [7:0] current_temp,
    input wire [7:0] threshold_temp,
    input wire [7:0] recovery_temp,
    output reg shutdown
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (current_temp >= threshold_temp) begin
            shutdown <= 1;
        end else if (current_temp < recovery_temp) begin
            shutdown <= 0;
        end
    end
endmodule