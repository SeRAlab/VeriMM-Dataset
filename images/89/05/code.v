module up_down_counter(
    input clk,
    input rst_n,
    input enable,
    input direction,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 0;
    else if (enable) begin
        if (direction)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule