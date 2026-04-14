module sync_down_counter_4bit(
    input clk,
    input rst_n,
    input en,
    output reg [3:0] count
);

    reg [3:0] count_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_reg <= 4'b1111;
        end else if (en) begin
            count_reg <= count_reg - 1;
        end
    end

    assign count = count_reg;

endmodule