module mpc_controller (
    input clk,
    input rst,
    input [3:0] current_state,
    input [3:0] control_input,
    output reg [3:0] next_state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        next_state <= 4'b0000; // Reset state to 0
    end else begin
        next_state <= current_state + control_input; // Update next state
    end
end

endmodule