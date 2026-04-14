module up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire dir,
    output reg [2:0] count
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 3'd0;
    else if (dir)
        count <= count + 3'd1;
    else
        count <= count - 3'd1;
end

endmodule