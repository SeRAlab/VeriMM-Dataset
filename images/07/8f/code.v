module noise_suppression_filter (
    input [4:0] in_signal,
    output reg out_signal
);
    always @(*) begin
        if ((in_signal[2] + in_signal[3] + in_signal[4]) >= 2)
            out_signal = 1;
        else
            out_signal = 0;
    end
endmodule