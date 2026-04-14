module top_module(
    input clk,
    input en,
    input data,
    output gated_clk
);reg gated_clk_reg;

    always @(posedge clk) begin
        if (en && data) begin
            gated_clk_reg <= 1'b1;
        end else begin
            gated_clk_reg <= 1'b0;
        end
    end

    assign gated_clk = gated_clk_reg;

endmodule