module top_module(input clk, input[2:0] n_lines, input start, output reg[15:0] score, output reg[7:0] level, input rst);reg[3:0] lines;


always @(posedge clk)
begin
    if(start) begin
        score <= score + n_lines * n_lines * level;
        lines <= lines + n_lines;
    end
    if(lines >= 6) begin
        lines <= 0;
        level <= level + 8'd1;
    end
    if(rst) begin
        level <= 1;
        lines <= 0;
        score <= 0;
    end
end

endmodule