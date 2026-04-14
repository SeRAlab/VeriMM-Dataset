module mpc_controller(
    input [7:0] current_state,
    input [7:0] setpoint,
    input [3:0] gain,
    output [15:0] control_signal
);
    assign control_signal = (setpoint - current_state) * gain;
endmodule