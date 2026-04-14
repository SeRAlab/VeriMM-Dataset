module top_module(clk, rst, en, q);input clk, rst, en;
    output reg [3:0] q;

    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            q <= 4'b0000;
        end else if (en == 1) begin
            q <= q + 1;
        end
    end

endmodule