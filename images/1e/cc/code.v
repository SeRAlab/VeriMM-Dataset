module pipeline_reg (
    input clk,
    input [4:0] in,
    output reg [4:0] out
);
    reg [4:0] stage [0:6];

    always @(posedge clk) begin
        stage[0] <= in;
        stage[1] <= stage[0];
        stage[2] <= stage[1];
        stage[3] <= stage[2];
        stage[4] <= stage[3];
        stage[5] <= stage[4];
        stage[6] <= stage[5];
        out <= stage[6];
    end
endmodule