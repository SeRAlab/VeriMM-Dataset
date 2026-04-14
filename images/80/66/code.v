module top_module(
    input clk,
    input rst,
    input left,
    input right,
    input up,
    input down,
    output reg [7:0] direction
);reg [31:0] clk_cnt;
    reg [3:0] button_last;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            clk_cnt <= 0;
            direction <= 8'b0;
            button_last <= 4'b0;
        end else begin
            if (clk_cnt == 5_000_000) begin
                clk_cnt <= 0;
                if (left && !button_last[0]) begin
                    direction <= 8'b0000_0001;
                    button_last <= 4'b0001;
                end else if (right && !button_last[1]) begin
                    direction <= 8'b0000_0010;
                    button_last <= 4'b0010;
                end else if (up && !button_last[2]) begin
                    direction <= 8'b0000_0011;
                    button_last <= 4'b0100;
                end else if (down && !button_last[3]) begin
                    direction <= 8'b0000_0100;
                    button_last <= 4'b1000;
                end else begin
                    direction <= 8'b0;
                end
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end
endmodule