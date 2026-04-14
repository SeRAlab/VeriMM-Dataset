module up_down_counter_8bit
(
    input clk,
    input rst_n,
    input en,
    input dir,
    output reg [7:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 8'd0;
    end else if (en) begin
        if (dir) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule