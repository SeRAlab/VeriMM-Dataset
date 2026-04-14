module gated_d_latch (
    input d,
    input clk,
    input en,
    output reg q
);

    always @(posedge clk) begin
        if (en) begin
            q <= d;
        end
    end

endmodule