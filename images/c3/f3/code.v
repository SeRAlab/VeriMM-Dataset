module LLbit_reg(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire LLbit_i,
    input wire we,
    output reg LLbit_o
);

    always @ (posedge clk) begin
        if (rst) begin
            LLbit_o <= 1'b0;
        end else if (flush) begin
            LLbit_o <= 1'b0;
        end else if (we) begin
            LLbit_o <= LLbit_i;
        end
    end

endmodule