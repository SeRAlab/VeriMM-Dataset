module pipeline_register(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1 <= data_in;
            data_out <= stage1 + 1;
        end
    end
endmodule