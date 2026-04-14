module rising_edge_detector (
    input clk,
    input d,
    output reg rising_edge
);
    reg d_prev;

    always @(posedge clk) begin
        rising_edge <= (d && !d_prev);
        d_prev <= d;
    end
endmodule