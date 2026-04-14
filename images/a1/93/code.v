module top_module(
    input clk_in, rst, enable, go,
    input [1:0] divider,
    output reg clk_out, pos_edge, neg_edge
);reg [1:0] cnt;
wire cnt_zero = (cnt == 2'h0);
wire cnt_one = (cnt == 2'h1);

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        cnt <= 2'h3;
        clk_out <= 1'b0;
        pos_edge <= 1'b0;
        neg_edge <= 1'b0;
    end else if (go && enable) begin
        if (cnt_zero) begin
            clk_out <= ~clk_out;
            pos_edge <= 1'b1;
            neg_edge <= 1'b0;
        end else if (cnt_one) begin
            pos_edge <= 1'b0;
            neg_edge <= 1'b1;
        end
        cnt <= cnt - 1;
    end else begin
        clk_out <= 1'b0;
        pos_edge <= 1'b0;
        neg_edge <= 1'b0;
        cnt <= 2'h3;
    end
end

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        cnt <= 2'h3;
    end else if (go && enable) begin
        if (cnt_zero) begin
            cnt <= divider - 1;
        end else if (cnt_one) begin
            cnt <= 2'h3;
        end
    end else begin
        cnt <= 2'h3;
    end
end

endmodule