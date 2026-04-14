module loadable_counter_with_terminal_count(
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] data,
    output reg [7:0] count,
    output reg terminal_count
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 8'b00000000; // Reset count to 0
        terminal_count <= 0; // Clear terminal count flag
    end else if (load) begin
        count <= data; // Load value from data input
        terminal_count <= 0; // Clear terminal count flag
    end else if (enable) begin
        if (count == 8'b11111111) begin
            terminal_count <= 1; // Set terminal count flag
        end else begin
            count <= count + 1; // Increment count
            terminal_count <= 0; // Clear terminal count flag
        end
    end

endmodule