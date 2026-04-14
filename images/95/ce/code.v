module top_module(clk, en, te, d, q);input clk, en, te, d;
    output q;
    reg q;

    always @(posedge clk) begin
        if (en && te) begin
            q <= d;
        end
    end
endmodule