module down_counter_6bit (
    input clk,
    input reset_n,
    input en,
    output reg [5:0] q);

always @(negedge clk) begin
    if (!reset_n)
        q <= 6'b111111;
    else if (en)
        q <= q - 1;
    end
    
endmodule