module pipeline_processor (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] data_out
);

    reg [3:0] stage1_out;

    // Stage 1: Incrementer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_out <= 4'b0000;
        end else begin
            stage1_out <= data_in + 4'b0001;
        end
    end

    // Stage 2: Multiplier
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= stage1_out * 2;
        end
    end

endmodule