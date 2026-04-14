module top_module(
    input clk,
    input rst,
    input load,
    input inc,
    input dec,
    input [3:0] data,
    output [3:0] count
);reg [3:0] count_reg;

always @(posedge clk) begin
    if (rst) begin
        count_reg <= 4'b0000;
    end else if (load) begin
        count_reg <= data;
    end else if (inc) begin
        if (count_reg == 4'b1111) begin
            count_reg <= 4'b0000;
        end else begin
            count_reg <= count_reg + 1;
        end
    end else if (dec) begin
        if (count_reg == 4'b0000) begin
            count_reg <= 4'b1111;
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg;

endmodule