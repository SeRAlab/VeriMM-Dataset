module up_down_counter (
    input clk,
    input reset_n,
    input en,
    input up_down,
    output reg [3:0] q);

always @(posedge clk) begin
    if (!reset_n)
        q <= 4'b0000;
    else if (en) begin
        if (up_down)
            q <= q + 1;
        else
            q <= q - 1;
    end
end

endmodule