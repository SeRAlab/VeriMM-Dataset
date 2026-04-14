module zero_crossing_detector(
    input clk,
    input reset,
    input signal,
    output reg zc_detected
);
    reg prev_signal;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_signal <= 0;
            zc_detected <= 0;
        end else begin
            zc_detected <= (prev_signal == 1'b0 && signal == 1'b1) || (prev_signal == 1'b1 && signal == 1'b0);
            prev_signal <= signal;
        end
    end
endmodule