module edge_detector(
    input clk,
    input reset,
    input signal,
    output reg edge_detected
);

    reg signal_delayed;

    always @(posedge clk) begin
        if (reset) begin
            signal_delayed <= 0;
            edge_detected <= 0;
        end else begin
            edge_detected <= signal & ~signal_delayed;
            signal_delayed <= signal;
        end
    end

endmodule