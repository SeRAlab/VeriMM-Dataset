module noise_suppression (
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    reg [4:0] prev_signal;

    always @(*) begin
        if ((signal_in ^ prev_signal) > 5'b00011) begin
            signal_out = prev_signal; // suppress noise
        end else begin
            signal_out = signal_in; // update output
        end
    end

    always @(signal_in) begin
        prev_signal <= signal_out; // update previous signal
    end
endmodule