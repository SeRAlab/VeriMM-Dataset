module top_module(clk, reset, enable, q1, q2, q3);input clk, reset, enable;
output [2:0] q1;
output [1:0] q2;
output [1:0] q3;

reg [2:0] q1_reg;
reg [1:0] q2_reg;
reg [1:0] q3_reg;

always @(posedge clk) begin
    if (reset) begin
        q1_reg <= 0;
        q2_reg <= 0;
        q3_reg <= 0;
    end else if (enable) begin
        if (q1_reg == 7) begin
            q1_reg <= 0;
            if (q2_reg == 3) begin
                q2_reg <= 0;
                if (q3_reg == 3) begin
                    q3_reg <= 0;
                end else begin
                    q3_reg <= q3_reg + 1;
                end
            end else begin
                q2_reg <= q2_reg + 1;
            end
        end else begin
            q1_reg <= q1_reg + 1;
        end
    end
end

assign q1 = q1_reg;
assign q2 = q2_reg;
assign q3 = q3_reg;

endmodule