module phase_detector (
    input wire clk,
    input wire reset,
    input wire signal_a,
    input wire signal_b,
    output reg phase_out
);

reg last_signal_a;
reg last_signal_b;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        phase_out <= 0;
        last_signal_a <= 0;
        last_signal_b <= 0;
    end else begin
        // Detect phase difference
        if (signal_a != last_signal_a && signal_b != last_signal_b) begin
            phase_out <= 1; // Signals are out-of-phase
        end else if (signal_a == last_signal_a && signal_b == last_signal_b) begin
            phase_out <= 0; // Signals are in-phase
        end
        last_signal_a <= signal_a;
        last_signal_b <= signal_b;
    end
end

endmodule