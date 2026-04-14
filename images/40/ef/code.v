module deadbeat_control (
    input clk,
    input rst,
    input signed [3:0] setpoint, // Desired setpoint
    input signed [3:0] current_state, // Current state of the system
    output reg signed [3:0] control_output // Control signal
);

reg signed [3:0] error; // Error signal

always @(posedge clk or posedge rst) begin
    if (rst) begin
        control_output <= 4'b0000;
    end else begin
        error <= setpoint - current_state; // Calculate error
        control_output <= error; // Directly use the error as control output
    end
end

endmodule