module up_down_counter(
    input clk,
    input rst,
    input enable,
    input up_down,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 3'b000;
    else if (enable) begin
        if (up_down)
            q <= q + 1;
        else
            q <= q - 1;
    end
end

endmodule