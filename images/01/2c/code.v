module mpc_controller (
    input clk,
    input reset,
    input [3:0] current_state,
    input control_signal,
    output reg [3:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 4'b0000; // Reset state to 0
        end else begin
            next_state <= current_state + control_signal; // Update next state
        end
    end
endmodule