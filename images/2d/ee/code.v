module timer_16bit (
    input clk,                // Clock signal
    input reset,              // Asynchronous reset
    input enable,             // Enable counting
    input [15:0] max_count,   // Maximum count value
    output reg [15:0] count   // Current count value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;       // Reset count to 0
    end else if (enable) begin
        if (count == max_count) begin
            count <= 16'b0;   // Wrap around
        end else begin
            count <= count + 1; // Increment count
        end
    end
end

endmodule