module deadbeat_controller (
    input clk,
    input reset,
    input [3:0] u, // Control input
    output reg [3:0] y // Control output
);
    reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
            y <= 4'b0000;
        end else begin
            // Deadbeat control logic
            y <= u; // Simple deadbeat response
            state <= y; // Update state
        end
    end
endmodule