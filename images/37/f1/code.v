module zero_crossing_detector (
    input wire clk,
    input wire rst,
    input wire signal,
    output reg rising_edge,
    output reg falling_edge
);

reg signal_prev;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        signal_prev <= 1'b0;
        rising_edge <= 1'b0;
        falling_edge <= 1'b0;
    end else begin
        rising_edge <= (signal_prev < 1'b0 && signal >= 1'b0);
        falling_edge <= (signal_prev > 1'b0 && signal <= 1'b0);
        signal_prev <= signal;
    end
end

endmodule