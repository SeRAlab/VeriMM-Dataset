module encoder_pipe_32bit
(
    input clk,
    input rst_n,
    input i_en,
    input [31:0] in_data,
    output reg [4:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [31:0] in_data_ff1;
reg [31:0] in_data_ff2;
reg [31:0] in_data_ff3;

reg [4:0] result_ff1;
reg [4:0] result_ff2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        o_en <= 1'b0;
    end
    else begin
        stage1 <= i_en;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        in_data_ff1 <= 32'd0;
        in_data_ff2 <= 32'd0;
        in_data_ff3 <= 32'd0;
    end
    else begin
        in_data_ff1 <= in_data;
        in_data_ff2 <= in_data_ff1;
        in_data_ff3 <= in_data_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_ff1 <= 5'd0;
        result_ff2 <= 5'd0;
        result <= 5'd0;
    end
    else if (stage1) begin
        result_ff1 <= (in_data_ff1[31] ? 5'd31 :
                       in_data_ff1[30] ? 5'd30 :
                       in_data_ff1[29] ? 5'd29 :
                       in_data_ff1[28] ? 5'd28 :
                       in_data_ff1[27] ? 5'd27 :
                       in_data_ff1[26] ? 5'd26 :
                       in_data_ff1[25] ? 5'd25 :
                       in_data_ff1[24] ? 5'd24 :
                       in_data_ff1[23] ? 5'd23 :
                       in_data_ff1[22] ? 5'd22 :
                       in_data_ff1[21] ? 5'd21 :
                       in_data_ff1[20] ? 5'd20 :
                       in_data_ff1[19] ? 5'd19 :
                       in_data_ff1[18] ? 5'd18 :
                       in_data_ff1[17] ? 5'd17 :
                       in_data_ff1[16] ? 5'd16 :
                       in_data_ff1[15] ? 5'd15 :
                       in_data_ff1[14] ? 5'd14 :
                       in_data_ff1[13] ? 5'd13 :
                       in_data_ff1[12] ? 5'd12 :
                       in_data_ff1[11] ? 5'd11 :
                       in_data_ff1[10] ? 5'd10 :
                       in_data_ff1[9]  ? 5'd9  :
                       in_data_ff1[8]  ? 5'd8  :
                       in_data_ff1[7]  ? 5'd7  :
                       in_data_ff1[6]  ? 5'd6  :
                       in_data_ff1[5]  ? 5'd5  :
                       in_data_ff1[4]  ? 5'd4  :
                       in_data_ff1[3]  ? 5'd3  :
                       in_data_ff1[2]  ? 5'd2  :
                       in_data_ff1[1]  ? 5'd1  :
                       in_data_ff1[0]  ? 5'd0  : 5'd0);
    end
    else if (stage2) begin
        result_ff2 <= result_ff1;
    end
    else if (stage3) begin
        result <= result_ff2;
    end
end

endmodule