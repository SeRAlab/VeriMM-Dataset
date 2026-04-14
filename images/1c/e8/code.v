module pipelined_processor (
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 5'b0;
            stage2 <= 5'b0;
            stage3 <= 5'b0;
            stage4 <= 5'b0;
            stage5 <= 5'b0;
            stage6 <= 5'b0;
            stage7 <= 5'b0;
            data_out <= 5'b0;
        end else begin
            stage1 <= data_in;                // Fetch
            stage2 <= stage1 + 1;             // Decode
            stage3 <= stage2 * 2;             // Execute
            stage4 <= stage3 + 3;             // Memory
            stage5 <= stage4 - 4;             // WriteBack
            stage6 <= stage5;                  // Output
            stage7 <= stage6;                  // Final
            data_out <= stage7;                // Final output to register
        end
    end
endmodule