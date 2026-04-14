module down_counter_7bit (
    input clk,
    input reset_n,
    input en,
    output reg [6:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 7'b1111111;
    else if (en)
        q <= q - 1;
    end
    
endmodule