module top_module(clk, resetn, enable, count);input clk;
input resetn;
input enable;
output reg [3:0] count;

always @(posedge clk) begin
    if (resetn == 0) begin
        count <= 4'b0000;
    end
    else if (enable == 1) begin
        count <= count + 1;
    end
end

endmodule