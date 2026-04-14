module zero_crossing_detector(
    input clk,
    input rst,
    input signal_in,
    output reg zero_cross,
    output reg state
);
    reg prev_signal;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            zero_cross <= 0;
            state <= 0;
            prev_signal <= 0;
        end else begin
            zero_cross <= (signal_in && !prev_signal) || (!signal_in && prev_signal);
            prev_signal <= signal_in;
            if (zero_cross) begin
                state <= ~state;
            end
        end
    end
endmodule