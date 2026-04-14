module edge_detector(
    input clk,
    output reg posedge_out
);
    reg clk_prev;

    always @(posedge clk) begin
        posedge_out <= (clk && !clk_prev);
        clk_prev <= clk;
    end
endmodule