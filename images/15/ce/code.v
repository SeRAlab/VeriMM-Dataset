module pipeline_processor(
    input clk,
    input rst,
    input [4:0] in_data,
    output reg [4:0] out_data
);
    reg [4:0] stage [0:6]; // 7 pipeline stages

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data <= 5'b0;
            stage[0] <= 5'b0;
            stage[1] <= 5'b0;
            stage[2] <= 5'b0;
            stage[3] <= 5'b0;
            stage[4] <= 5'b0;
            stage[5] <= 5'b0;
            stage[6] <= 5'b0;
        end else begin
            stage[0] <= in_data + 1; // Increment by 1
            stage[1] <= stage[0];
            stage[2] <= stage[1];
            stage[3] <= stage[2];
            stage[4] <= stage[3];
            stage[5] <= stage[4];
            stage[6] <= stage[5];
            out_data <= stage[6];
        end
    end
endmodule