module pipeline (
    input clk,
    input enable,
    input [3:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1_out;

    always @(posedge clk) begin
        if (enable) begin
            stage1_out <= data_in + 1; // First stage: increment
            data_out <= stage1_out * 2; // Second stage: double the output of stage 1
        end
    end
endmodule