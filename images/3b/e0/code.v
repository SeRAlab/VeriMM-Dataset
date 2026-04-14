module deadbeat_controller(
    input [3:0] ref_signal,
    input [3:0] system_output,
    output reg [3:0] control_signal
);
    always @(*) begin
        control_signal = ref_signal - system_output; // Simple deadbeat control law
    end
endmodule