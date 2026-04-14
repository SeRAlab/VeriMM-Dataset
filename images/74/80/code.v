module binary_counter (
    input clk,
    input enable,
    output [11:0] count,
    output terminal_count );reg [11:0] count_reg;

always @(posedge clk) begin
    if (enable) begin
        if (count_reg == 12'b111111111111)
            count_reg <= 12'b000000000000;
        else
            count_reg <= count_reg + 1;
    end
end

assign count = count_reg;
assign terminal_count = (count_reg == 12'b111111111111);

endmodule