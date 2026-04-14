module top_module(
    input probe,
    input source_clk,
    output reg [2:0] source
);always @(posedge source_clk) begin
        if (probe) begin
            source <= 3'b0;
        end else begin
            source <= {source[1:0], 1'b0};
        end
    end

endmodule