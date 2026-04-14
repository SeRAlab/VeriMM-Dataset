module current_sensor (
    input clk,
    input reset,
    input [9:0] current_input,
    output reg alarm
);

// Threshold constant
parameter THRESHOLD = 10'b1000000000;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alarm <= 0; // Clear alarm on reset
    end else begin
        if (current_input > THRESHOLD) begin
            alarm <= 1; // Set alarm if current exceeds threshold
        end else begin
            alarm <= 0; // Clear alarm if current is within limit
        end
    end
end

endmodule