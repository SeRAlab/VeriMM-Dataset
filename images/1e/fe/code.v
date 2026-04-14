module edge_detector (
    input wire clk,
    input wire signal,
    output reg edge_detected
);

reg signal_prev;

always @(posedge clk) begin
    signal_prev <= signal;
    edge_detected <= (signal && ~signal_prev);
end

endmodule