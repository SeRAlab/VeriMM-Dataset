module deadbeat_controller(
    input clk,
    input rst,
    input [3:0] x_current, // Current state (4-bit input)
    input [3:0] r_input,   // Reference input (4-bit input)
    output reg [3:0] x_next // Next state (4-bit output)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x_next <= 4'b0000; // Reset state
    end else begin
        // Deadbeat control logic
        x_next <= r_input; // Directly set next state to reference input
    end
end

endmodule