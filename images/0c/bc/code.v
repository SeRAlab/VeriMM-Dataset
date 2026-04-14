module pipelined_processor (
    input clk,
    input reset,
    input [4:0] in_data,
    output reg [4:0] out_data
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
            out_data <= 0;
        end else begin
            stage1 <= in_data + 1;            // Increment
            stage2 <= stage1 + 10;            // Add 10
            stage3 <= stage2 - 5;             // Subtract 5
            stage4 <= stage3 * 2;             // Multiply by 2
            stage5 <= stage4 / 3;             // Divide by 3
            stage6 <= stage5 % 4;             // Modulus 4
            stage7 <= stage6 + 7;             // Add 7
            out_data <= stage7;
        end
    end
endmodule