module state_space_controller (
    input [1:0] state_vector,
    input [1:0] feedback_gain,
    output reg [3:0] control_signal
);
    always @(state_vector or feedback_gain) begin
        control_signal = state_vector * feedback_gain;
    end
endmodule