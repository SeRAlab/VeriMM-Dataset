module top_module(clk, rst, count, max_count);input clk, rst;
    output [3:0] count;
    output reg max_count; // Change to reg to assign in always block

    reg [3:0] count_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count_reg <= 4'b0;
            max_count <= 1'b0; // Initialize max_count to 0 on reset
        end else begin
            if (count_reg == 4'hf) begin
                count_reg <= 4'b0;
                max_count <= 1'b1;
            end else begin
                count_reg <= count_reg + 1'b1;
                max_count <= 1'b0;
            end
        end
    end

    assign count = count_reg;
endmodule