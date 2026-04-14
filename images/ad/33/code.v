module binary_counter_with_terminal_count(
    input clk,
    input reset,
    output reg [11:0] count,
    output reg terminal_count
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 12'b000000000000; // Reset counter to 0
        terminal_count <= 0; // Clear terminal count flag
    end else begin
        if (count == 12'b111111111111) begin
            terminal_count <= 1; // Set terminal count flag
            count <= 12'b000000000000; // Reset counter to 0 after reaching max value
        end else begin
            count <= count + 1; // Increment counter
            terminal_count <= 0; // Clear terminal count flag
        end
    end

endmodule