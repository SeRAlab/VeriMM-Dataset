module mpc_controller (
    input clk,
    input reset,
    input [1:0] current_state,
    input [1:0] control_input,
    output reg [1:0] next_state
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        next_state <= 2'b00; // Reset the state
    end else begin
        next_state <= (current_state + control_input) % 4; // Calculate next state
    end
end

endmodule