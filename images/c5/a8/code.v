module clock_gate (
    input clk,
    input en,
    input te,
    output reg en_clk
);

always @(*) begin
    if (en && te) begin
        en_clk = clk;
    end
    else begin
        en_clk = 1'b0;
    end
end

endmodule