module gray_counter (
    input clk,
    input reset_n,
    input en,
    output reg [11:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 12'b000000000000;
    else if (en) begin
        q <= q ^ (q >> 1);
    end
end

endmodule