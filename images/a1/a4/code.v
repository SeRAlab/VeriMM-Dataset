module up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire up_down,
    output reg [3:0] count_out
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count_out <= 4'b0000;
    else if (up_down)
        count_out <= count_out + 1;
    else
        count_out <= count_out - 1;
end

endmodule