module pipeline_register (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1 <= data_in;
            data_out <= stage1;
        end
    end
endmodule