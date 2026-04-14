module deadbeat_controller (
    input [3:0] desired_output,
    input [3:0] current_output,
    output [3:0] control_signal
);
    assign control_signal = desired_output - current_output;
endmodule