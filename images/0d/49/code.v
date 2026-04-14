module timer_16bit (
    input clk,
    input reset,
    input enable,
    output reg [15:0] timer_value
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer_value <= 16'b0;  // Reset timer to 0
        end else if (enable) begin
            if (timer_value == 16'hFFFF) begin
                timer_value <= 16'b0;  // Roll over
            end else begin
                timer_value <= timer_value + 1'b1;  // Increment timer
            end
        end
    end

endmodule