module edge_detector (
    input clk,
    input reset,
    input signal_in,
    output reg edge_detected
);
    reg signal_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            edge_detected <= 0;
            signal_prev <= 0;
        end else begin
            edge_detected <= (signal_in && !signal_prev);
            signal_prev <= signal_in;
        end
    end
endmodule