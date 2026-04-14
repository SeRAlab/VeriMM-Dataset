module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);reg [3:0] stage1, stage2, stage3, stage4;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            stage1 <= 4'b0000;
            stage2 <= 4'b0000;
            stage3 <= 4'b0000;
            stage4 <= 4'b0000;
            q <= 4'b0000;
        end else if (load) begin
            stage1 <= data[0];
            stage2 <= data[1];
            stage3 <= data[2];
            stage4 <= data[3];
            q <= data;
        end else if (ena) begin
            stage1 <= q[0];
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
            q <= {stage4, q[3:1]};
        end
    end

endmodule