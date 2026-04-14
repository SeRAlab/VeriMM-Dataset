module md5_simple (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    output reg [127:0] hash_out
);

    reg [31:0] stage1, stage2, stage3, stage4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_out <= 128'b0;
            stage1 <= 32'b0;
            stage2 <= 32'b0;
            stage3 <= 32'b0;
            stage4 <= 32'b0;
        end else begin
            stage1 <= (data_in + 32'hd76aa478) ^ (stage1 << 5);
            stage2 <= (stage1 + 32'he8c7b756) ^ (stage2 << 7);
            stage3 <= (stage2 + 32'h242070db) ^ (stage3 << 12);
            stage4 <= (stage3 + 32'hc1bdceee) ^ (stage4 << 17);
            hash_out <= {stage1, stage2, stage3, stage4};
        end
    end
endmodule