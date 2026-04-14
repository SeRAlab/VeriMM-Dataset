module zero_crossing_detector (
    input wire clk,
    input wire signal,
    output reg pulse
);
    reg signal_prev;

    always @(posedge clk) begin
        pulse <= 0; // Default pulse output
        if ((signal_prev == 1 && signal == 0) || (signal_prev == 0 && signal == 1)) begin
            pulse <= 1; // Set pulse on zero crossing
        end
        signal_prev <= signal; // Store previous signal value
    end
endmodule