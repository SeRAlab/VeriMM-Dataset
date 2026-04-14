module edge_detect(
    input clk,
    input rst_n,
    input edge_in,
    output reg edge_out
);

reg prev_edge;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        prev_edge <= 0;
    else
        prev_edge <= edge_in;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        edge_out <= 0;
    else if (edge_in && !prev_edge)
        edge_out <= 1;
    else
        edge_out <= 0;
end

endmodule