module up_down_counter
    (
        input clk,
        input enable,
        input dir,
        input rst,
        output reg [2:0] count
    );

    reg [2:0] count_reg;

    always @(posedge clk) begin
        if (rst) begin
            count_reg <= 3'b000;
        end else if (enable) begin
            if (dir) begin
                count_reg <= count_reg + 1;
            end else begin
                count_reg <= count_reg - 1;
            end
        end
    end

    assign count = count_reg;

endmodule