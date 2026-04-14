module up_down_counter(
    input clk,
    input rst_n,
    input dir,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'b0000;
    else if (dir)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule