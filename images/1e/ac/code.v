module pipeline (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1_reg <= data_in + 1;
            data_out <= stage1_reg + 2;
        end
    end
endmodule