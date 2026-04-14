module edge_detector (
    input wire clk,
    input wire reset,
    input wire signal,
    output reg edge_detected
);
    reg signal_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            edge_detected <= 0;
            signal_prev <= 0;
        end else begin
            edge_detected <= (signal && !signal_prev);
            signal_prev <= signal;
        end
    end
endmodule