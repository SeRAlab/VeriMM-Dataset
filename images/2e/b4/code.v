module pipeline(
    input clk,
    input reset,
    input [3:0] in_data,
    output reg [3:0] out_data
);
    reg [3:0] stage [0:6]; // 7 stages

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage[0] <= 4'b0000;
            stage[1] <= 4'b0000;
            stage[2] <= 4'b0000;
            stage[3] <= 4'b0000;
            stage[4] <= 4'b0000;
            stage[5] <= 4'b0000;
            stage[6] <= 4'b0000;
            out_data <= 4'b0000;
        end else begin
            stage[0] <= in_data + 1;
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