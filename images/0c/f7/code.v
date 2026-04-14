module pipelined_processor (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] result_out
);
    reg [3:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage0 <= 4'b0000;
            stage1 <= 4'b0000;
            stage2 <= 4'b0000;
            stage3 <= 4'b0000;
            stage4 <= 4'b0000;
            stage5 <= 4'b0000;
            stage6 <= 4'b0000;
            result_out <= 4'b0000;
        end else begin
            // Stage 0: Fetching data
            stage0 <= data_in;

            // Stage 1: Decoding data (simulating a simple operation)
            stage1 <= stage0 + 4'b0001;

            // Stage 2: Executing operation
            stage2 <= stage1 * 4'b0010;

            // Stage 3: Memory Access (simulating)
            stage3 <= stage2;

            // Stage 4: Write Back
            stage4 <= stage3;

            // Stage 5: Data Forwarding
            stage5 <= stage4;

            // Stage 6: Final output stage
            stage6 <= stage5;
            result_out <= stage6;
        end
    end
endmodule