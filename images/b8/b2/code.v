module top_module(clk, rst, chg, theme);input clk, rst, chg;
output reg [3:0] theme;

reg [3:0]n_theme;

always@(posedge clk) begin
    if(rst == 1'b1) 
        theme <= 0;
    else
        theme <= n_theme;
end

always@(*) begin
    if(chg == 1'b1) begin
        n_theme = (theme == 2)? 0: theme + 1;
    end
    else begin
        n_theme = theme;
    end
end

endmodule