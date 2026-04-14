module pipeline_register (
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 5'b0;
            data_out <= 5'b0;
        end else begin
            stage1 <= data_in;
            data_out <= stage1;
        end
    end
endmodule