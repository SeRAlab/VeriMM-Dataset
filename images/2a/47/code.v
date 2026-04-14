module mpc_control (
    input [3:0] setpoint,
    input [3:0] measured,
    output reg [3:0] control_signal
);
    always @(*) begin
        // Calculate the difference
        control_signal = setpoint - measured;

        // Constrain to 4-bit signed range (-8 to 7)
        if (control_signal > 4'b0111) begin
            control_signal = 4'b0111; // max 7
        end else if (control_signal < 4'b1000) begin
            control_signal = 4'b1000; // min -8
        end
    end
endmodule