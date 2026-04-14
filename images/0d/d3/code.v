module pipeline_register (
    input clk,
    input rst,
    input valid,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg valid_out
);
    reg [31:0] stage [6:0]; // 7 stages

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage[0] <= 32'b0;
            stage[1] <= 32'b0;
            stage[2] <= 32'b0;
            stage[3] <= 32'b0;
            stage[4] <= 32'b0;
            stage[5] <= 32'b0;
            stage[6] <= 32'b0;
            valid_out <= 0;
        end else begin
            if (valid) begin
                stage[0] <= data_in;
            end
            stage[1] <= stage[0];
            stage[2] <= stage[1];
            stage[3] <= stage[2];
            stage[4] <= stage[3];
            stage[5] <= stage[4];
            stage[6] <= stage[5];
            valid_out <= (stage[6] != 32'b0);
            data_out <= stage[6];
        end
    end
endmodule