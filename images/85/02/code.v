module up_counter (
    input clk,
    input reset_n,
    input en,
    output reg [3:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 4'b0000;
    else if (en) begin
        q <= q + 1;
    end
end

endmodule