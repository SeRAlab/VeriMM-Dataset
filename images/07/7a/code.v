module zero_crossing_detector(
    input clk,
    input enable,
    input signal_in,
    output reg crossing_out
);
    reg signal_prev;

    always @(posedge clk) begin
        if (enable) begin
            if ((signal_prev < 1'b1 && signal_in >= 1'b1) || (signal_prev >= 1'b1 && signal_in < 1'b1)) begin
                crossing_out <= ~crossing_out;
            end
            signal_prev <= signal_in;
        end
    end
endmodule