module top_module(
    input CLK, RST, CTRL,
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] SUM,
    output reg [3:0] DIFF,
    output reg COUT
);reg [3:0] sum_stage1;
reg [3:0] diff_stage1;
reg [3:0] sum_stage2;
reg [3:0] diff_stage2;

always @(posedge CLK) begin
    if (RST) begin
        SUM <= 4'b0;
        DIFF <= 4'b0;
        COUT <= 1'b0;
        sum_stage1 <= 4'b0;
        diff_stage1 <= 4'b0;
        sum_stage2 <= 4'b0;
        diff_stage2 <= 4'b0;
    end else begin
        case (CTRL)
            2'b00: begin // compute sum and difference
                sum_stage1 <= A + B;
                diff_stage1 <= A - B;
                sum_stage2 <= sum_stage1;
                diff_stage2 <= diff_stage1;
            end
            2'b01: begin // compute sum only
                sum_stage1 <= A + B;
                sum_stage2 <= sum_stage1;
            end
            2'b10: begin // compute difference only
                diff_stage1 <= A - B;
                diff_stage2 <= diff_stage1;
            end
            default: begin // do nothing
                sum_stage1 <= sum_stage2;
                diff_stage1 <= diff_stage2;
                sum_stage2 <= sum_stage2;
                diff_stage2 <= diff_stage2;
            end
        endcase
        
        SUM <= sum_stage2;
        DIFF <= diff_stage2;
        COUT <= sum_stage1[4];
    end
end

endmodule