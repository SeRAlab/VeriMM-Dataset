module pipeline_processor(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage_1, stage_2, stage_3, stage_4, stage_5, stage_6;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage_1 <= 0;
            stage_2 <= 0;
            stage_3 <= 0;
            stage_4 <= 0;
            stage_5 <= 0;
            stage_6 <= 0;
            data_out <= 0;
        end else begin
            stage_1 <= data_in;                // Input values
            stage_2 <= stage_1 + 1;            // Add 1
            stage_3 <= stage_2 * 2;            // Multiply by 2
            stage_4 <= stage_3 - 3;            // Subtract 3
            stage_5 <= stage_4 / 4;            // Divide by 4
            stage_6 <= stage_5 % 5;            // Modulus 5
            data_out <= stage_6;               // Store the output
        end
    end
endmodule