module top_module(input clk, input [7:0] divisor, output [7:0] div_cnt, output div_clk);reg [7:0] div_cnt_ = 0;
    reg div_clk_;
    assign div_cnt = div_cnt_;
    assign div_clk = div_clk_;

    always @(posedge clk)
    begin
        if(div_cnt == divisor) begin
            div_cnt_ <= 8'd0;
            div_clk_ = !div_clk_;
        end else
            div_cnt_ <= div_cnt_ + 1;
    end

endmodule