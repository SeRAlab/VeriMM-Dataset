module up_down_counter (
    input clk,
    input reset,
    input en,
    input up,
    output reg [2:0] q);always @(posedge clk) begin
    if (reset)
        q <= 3'b000;
    else if (en) begin
        if (up)
            q <= q + 1;
        else
            q <= q - 1;
    end
end
endmodule