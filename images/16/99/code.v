module rising_edge_detector (
    input wire clk,
    output reg rising_edge
);
    reg clk_prev;

    always @(posedge clk) begin
        rising_edge <= (clk_prev == 0) && (clk == 1);
        clk_prev <= clk;
    end
endmodule