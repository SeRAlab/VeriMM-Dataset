module up_down_counter (
    input clk,
    input reset_n,
    input en,
    input dir,
    output reg [23:0] q);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 24'b000000000000000000000000;
    else if (en) begin
        if (dir)
            q <= q + 1;
        else
            q <= q - 1;
    end
end

endmodule