module pipeline_register (
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 5'b0;
            data_out <= 5'b0;
        end else begin
            stage1_reg <= data_in; // First stage
            data_out <= stage1_reg; // Second stage
        end
    end
endmodule