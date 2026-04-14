module pipeline_processor (
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
            data_out <= 0;
        end else begin
            stage1 <= data_in + 1;           // Increment
            stage2 <= stage1 * 2;             // Multiply by 2
            stage3 <= stage2 ^ 5'b11111;      // Toggle bits
            stage4 <= stage3 - 1;             // Decrement
            stage5 <= stage4 + 3;             // Add 3
            stage6 <= stage5 >> 1;            // Right shift by 1
            stage7 <= stage6 & 5'b10101;      // AND with 10101
            data_out <= stage7;               // Final output
        end
    end
endmodule