module top_module(
    input clk, start_stop, 
    input [31:0] max_count,
    output [31:0] count,
    output max_reached
    );reg [31:0] count_reg;
    reg max_reached_reg;

    always @(posedge clk) begin
        if (start_stop) begin
            if (count_reg == max_count) begin
                count_reg <= 0;
                max_reached_reg <= 1;
            end else begin
                count_reg <= count_reg + 1;
                max_reached_reg <= 0;
            end
        end else begin
            max_reached_reg <= 0;
        end
    end

    assign count = count_reg;
    assign max_reached = max_reached_reg;

endmodule