module binary_counter
    (
        input clk,
        input enable,
        input rst,
        output reg [3:0] count
    );

    reg [3:0] count_reg;

    always @(posedge clk) begin
        if (rst) begin
            count_reg <= 4'b0000;
        end else if (enable) begin
            count_reg <= count_reg + 1;
        end
    end

    assign count = count_reg;

endmodule