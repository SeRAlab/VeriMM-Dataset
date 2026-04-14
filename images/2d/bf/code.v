module clock_gated_dff (
    input wire clk,
    input wire enable,
    input wire d,
    output reg q
);

always @(posedge clk) begin
    if (enable) begin
        q <= d;
    end
    // When clock is low or enable is low, the output holds its previous value
end

endmodule