module d_ff_en_ce (
    input clk,
    input en,
    input enclk,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (en && enclk) begin
        q <= d;
    end
end

endmodule