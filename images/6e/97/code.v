module up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire up_down,
    output reg [1:0] count
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 2'd0;
    else if (enable) begin
        if (up_down)
            count <= count + 1'b1;
        else
            count <= count - 1'b1;
    end
end

endmodule