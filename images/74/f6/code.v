module reg_file_256bit
(
    input clk,
    input rst_n,
    input i_en,
    input wr_en,
    input [2:0] wr_addr,
    input [255:0] wr_data,
    input [2:0] rd_addr,
    output reg [255:0] data_out,
    output reg o_en
);

reg [255:0] reg_file[7:0];
reg stage1;
reg stage2;
reg stage3;

reg i_en_ff1;
reg i_en_ff2;
reg i_en_ff3;

reg wr_en_ff1;
reg wr_en_ff2;
reg wr_en_ff3;

reg [2:0] wr_addr_ff1;
reg [2:0] wr_addr_ff2;
reg [2:0] wr_addr_ff3;

reg [255:0] wr_data_ff1;
reg [255:0] wr_data_ff2;
reg [255:0] wr_data_ff3;

reg [2:0] rd_addr_ff1;
reg [2:0] rd_addr_ff2;
reg [2:0] rd_addr_ff3;

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
        i_en_ff1 <= 1'b0;
        i_en_ff2 <= 1'b0;
        i_en_ff3 <= 1'b0;
        wr_en_ff1 <= 1'b0;
        wr_en_ff2 <= 1'b0;
        wr_en_ff3 <= 1'b0;
        wr_addr_ff1 <= 3'd0;
        wr_addr_ff2 <= 3'd0;
        wr_addr_ff3 <= 3'd0;
        wr_data_ff1 <= 256'd0;
        wr_data_ff2 <= 256'd0;
        wr_data_ff3 <= 256'd0;
        rd_addr_ff1 <= 3'd0;
        rd_addr_ff2 <= 3'd0;
        rd_addr_ff3 <= 3'd0;
    end
    else begin
        i_en_ff1 <= i_en;
        i_en_ff2 <= i_en_ff1;
        i_en_ff3 <= i_en_ff2;
        wr_en_ff1 <= wr_en;
        wr_en_ff2 <= wr_en_ff1;
        wr_en_ff3 <= wr_en_ff2;
        wr_addr_ff1 <= wr_addr;
        wr_addr_ff2 <= wr_addr_ff1;
        wr_addr_ff3 <= wr_addr_ff2;
        wr_data_ff1 <= wr_data;
        wr_data_ff2 <= wr_data_ff1;
        wr_data_ff3 <= wr_data_ff2;
        rd_addr_ff1 <= rd_addr;
        rd_addr_ff2 <= rd_addr_ff1;
        rd_addr_ff3 <= rd_addr_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 256'd0;
    end
    else if (wr_en_ff3 && i_en_ff3) begin
        reg_file[wr_addr_ff3] <= wr_data_ff3;
    end
    else if (i_en_ff3) begin
        data_out <= reg_file[rd_addr_ff3];
    end
end

endmodule