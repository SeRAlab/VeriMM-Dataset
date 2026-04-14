module rising_edge_detector(
    input                 clk,
    input                 rst,
    input                 signal_in,
    
    output reg            edge_detected
);

reg signal_in_d;

// Edge detector implementation
always @(posedge clk) begin
    if (rst) begin
        signal_in_d <= 1'b0;
        edge_detected <= 1'b0;
    end
    else begin
        signal_in_d <= signal_in;
        edge_detected <= signal_in & ~signal_in_d;
    end
end

endmodule