module up_down_counter_3bit
(
    input clk,
    input rst,
    input dir,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 3'd0;
    end else if (dir) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule