module EdgeDetector (
	input clk,
	input rst_n,
	input in_signal,
	output reg out_pulse
);
    reg prev_signal;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_signal <= 0;
            out_pulse <= 0;
        end else begin
            out_pulse <= (in_signal && !prev_signal);
            prev_signal <= in_signal;
        end
    end
endmodule