module mpc_controller (
    input wire [3:0] prev_control,
    input wire disturbance,
    output reg [3:0] control_signal
);
    always @(prev_control or disturbance) begin
        if (disturbance) begin
            control_signal = (prev_control + 1) % 16; // Increment with wrap-around
        end else begin
            control_signal = prev_control; // Maintain previous
        end
    end
endmodule