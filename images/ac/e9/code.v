module counter_sync_16bit
(
    input clk,
    input rst_n,
    input load,
    input [15:0] load_val,
    input en,
    output reg [15:0] count,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg load_ff1;
reg load_ff2;
reg load_ff3;

reg en_ff1;
reg en_ff2;
reg en_ff3;

reg [15:0] load_val_ff1;
reg [15:0] load_val_ff2;
reg [15:0] load_val_ff3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        o_en <= 1'b0;
    end
    else begin
        stage1 <= en | load;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        load_ff1 <= 1'b0;
        load_ff2 <= 1'b0;
        load_ff3 <= 1'b0;
        en_ff1 <= 1'b0;
        en_ff2 <= 1'b0;
        en_ff3 <= 1'b0;
        load_val_ff1 <= 16'd0;
        load_val_ff2 <= 16'd0;
        load_val_ff3 <= 16'd0;
    end
    else begin
        load_ff1 <= load;
        load_ff2 <= load_ff1;
        load_ff3 <= load_ff2;
        en_ff1 <= en;
        en_ff2 <= en_ff1;
        en_ff3 <= en_ff2;
        load_val_ff1 <= load_val;
        load_val_ff2 <= load_val_ff1;
        load_val_ff3 <= load_val_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 16'd0;
    end
    else if (load_ff3) begin
        count <= load_val_ff3;
    end
    else if (en_ff3) begin
        count <= count + 16'd1;
    end
end

endmodule