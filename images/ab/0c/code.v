module edge_detector(
    input clk,
    input rst_n,
    input signal_in,

    output reg edge_detected
);

reg signal_delayed;

// Edge detection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        signal_delayed <= 1'b0;
    else
        signal_delayed <= signal_in;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        edge_detected <= 1'b0;
    else
        edge_detected <= signal_in & ~signal_delayed;
end

endmodule