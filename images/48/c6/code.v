module sync_up_counter_4bit(
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

    reg [3:0] count_reg;

    always @(posedge clk) begin
        if (rst) begin
            count_reg <= 4'b0000;
        end else if (en) begin
            count_reg <= count_reg + 1;
        end
    end

    assign count = count_reg;

endmodule