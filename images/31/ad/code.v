module pipeline_register (
    input clk,
    input reset,
    input [3:0] data_in,
    input ctrl,
    output reg [3:0] data_out
);

    reg [3:0] stage1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 4'b0000;
            data_out <= 4'b0000;
        end else begin
            stage1 <= data_in;
            if (ctrl) begin
                data_out <= stage1;
            end else begin
                data_out <= 4'b0000;
            end
        end
    end
endmodule