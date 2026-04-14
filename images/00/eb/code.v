module pipeline_processor (
    input wire clk,
    input wire rst,
    input wire [4:0] in,
    output reg [4:0] out
);

    reg [4:0] stage[0:6];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage[0] <= 5'b0;
            stage[1] <= 5'b0;
            stage[2] <= 5'b0;
            stage[3] <= 5'b0;
            stage[4] <= 5'b0;
            stage[5] <= 5'b0;
            stage[6] <= 5'b0;
            out <= 5'b0;
        end else begin
            stage[0] <= in;
            stage[1] <= stage[0] + 1;
            stage[2] <= stage[1] + 1;
            stage[3] <= stage[2] + 1;
            stage[4] <= stage[3] + 1;
            stage[5] <= stage[4] + 1;
            stage[6] <= stage[5] + 1;
            out <= stage[6];
        end
    end
endmodule