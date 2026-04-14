module timer (
    input clk,
    input reset,
    input load,
    input [31:0] load_value,
    output reg [31:0] timer_value
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer_value <= 32'b0; // Reset the timer to zero
        end else if (load) begin
            timer_value <= load_value; // Load the new value
        end else begin
            timer_value <= timer_value + 1; // Increment the timer
        end
    end
endmodule