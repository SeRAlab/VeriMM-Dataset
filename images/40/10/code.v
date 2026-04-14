module deadbeat_controller(
    input [3:0] current_state,
    input [3:0] desired_state,
    output reg [3:0] control_action
);
    always @(*) begin
        control_action = desired_state - current_state; // Deadbeat control law
    end
endmodule