module temp_monitor(
    input [4:0] temperature, // 5-bit input for temperature in Celsius
    input reset,             // Reset signal
    input clk,               // Clock signal
    output reg warning       // Warning signal
);
    parameter HIGH_THRESHOLD = 5'b11001; // 25 degrees Celsius
    parameter LOW_THRESHOLD = 5'b10111;  // 23 degrees Celsius

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            warning <= 0;
        end else begin
            if (temperature > HIGH_THRESHOLD) begin
                warning <= 1;
            end else if (temperature < LOW_THRESHOLD) begin
                warning <= 0;
            end
        end
    end
endmodule