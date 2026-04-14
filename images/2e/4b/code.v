module reset_controller (
    input clk,
    input reset_in,
    output reg reset_out
);
    parameter RESET_DURATION = 5; // Duration of reset in clock cycles
    reg [3:0] count; // 4-bit counter to keep track of duration

    always @(posedge clk or posedge reset_in) begin
        if (reset_in) begin
            reset_out <= 1'b1; // Assert reset output
            count <= 0; // Initialize counter
        end else if (count < RESET_DURATION) begin
            count <= count + 1; // Increment counter
        end else begin
            reset_out <= 1'b0; // Deassert reset output after duration
        end
    end
endmodule