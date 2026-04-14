module top_module(clk, rst_n, en, cnt);output reg [7:0] cnt;
input clk, en, rst_n;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= 8'b0000_0001;
    else if(en)
        cnt <= {cnt[6:0], cnt[7]};
end

endmodule