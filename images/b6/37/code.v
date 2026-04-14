module up_counter_neg_clk (
    input clk_n,
    input reset_n,
    input en,
    output reg [5:0] q);

always @(negedge clk_n) begin
    if (!reset_n)
        q <= 6'b000000;
    else if (en)
        q <= q + 1;
    end
    
endmodule