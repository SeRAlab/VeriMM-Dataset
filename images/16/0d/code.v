module zero_crossing_detector (
    input clk,
    input rst,
    input signal_in,
    output reg cross_detected
);
    reg prev_signal;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_signal <= 0;
            cross_detected <= 0;
        end else begin
            if ((prev_signal == 0 && signal_in == 1) || (prev_signal == 1 && signal_in == 0)) begin
                cross_detected <= 1;  // Toggle on crossing
            end else begin
                cross_detected <= 0;  // Reset on same level
            end
            prev_signal <= signal_in;  // Store previous state
        end
    end
endmodule