module top_module(din, rst_l, en, clk, q);input din;
input rst_l;
input en;
input clk;
output q;

reg q;

always @(posedge clk) begin
    if (rst_l == 0) begin
        q <= 0;
    end
    else if (en == 1) begin
        q <= din;
    end
end

endmodule