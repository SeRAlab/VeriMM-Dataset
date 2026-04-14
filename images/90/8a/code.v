module top_module(
    input wire clk,
    input wire n_rst,
    input wire up,
    input wire dn,
    output reg [31:0] cnt,
    output reg [3:0] cnt_1k,
    input wire in1,
    input wire in2,
    output reg out1,
    output reg out2
);reg [31:0] cnt_reg;
    reg [3:0] cnt_1k_reg;
    reg [31:0] cnt_1k_divider;
    reg [31:0] cnt_1k_divider_reg;
    reg cnt_1k_enable;

    always @(posedge clk or negedge n_rst) begin
        if (~n_rst) begin
            cnt_reg <= 0;
            cnt_1k_reg <= 0;
            cnt_1k_divider <= 0;
            cnt_1k_divider_reg <= 0;
            cnt_1k_enable <= 0;
        end else begin
            if (up && ~dn) begin
                cnt_reg <= cnt_reg + 1;
            end else if (~up && dn) begin
                cnt_reg <= cnt_reg - 1;
            end
            cnt <= cnt_reg;

            cnt_1k_enable <= 1;
            if (cnt_1k_divider_reg == 0) begin
                cnt_1k_divider_reg <= 100000;
                if (cnt_1k_reg == 4'hf) begin
                    cnt_1k_reg <= 0;
                end else begin
                    cnt_1k_reg <= cnt_1k_reg + 1;
                end
            end else begin
                cnt_1k_divider_reg <= cnt_1k_divider_reg - 1;
            end

            if (cnt_1k_divider_reg == 1) begin
                cnt_1k_divider_reg <= 0;
            end
            cnt_1k_divider <= cnt_1k_divider_reg;
            cnt_1k <= cnt_1k_reg;
        end
    end

endmodule