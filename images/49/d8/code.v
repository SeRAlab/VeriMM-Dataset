module top_module(clk, rst, in, out);input clk, rst;
    input [3:0] in;
    output reg [7:0] out;
    reg [3:0] in_reg;
    reg valid;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            in_reg <= 4'b0;
            valid <= 0;
            out <= 8'b0;
        end
        else begin
            in_reg <= in;
            if (in_reg == in && valid) begin
                out <= $signed({6'b0, in_reg}) + 1'b1;
            end
            else begin
                valid <= 1;
            end
        end
    end
endmodule