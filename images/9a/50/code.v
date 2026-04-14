module barrel_shifter_128bit
(
    input clk,
    input rst_n,
    input i_en,
    input [127:0] data_in,
    input [6:0] shift_val,
    output reg [127:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [127:0] data_in_ff1;
reg [127:0] data_in_ff2;
reg [127:0] data_in_ff3;

reg [6:0] shift_val_ff1;
reg [6:0] shift_val_ff2;
reg [6:0] shift_val_ff3;

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
        data_in_ff1 <= 128'd0;
        data_in_ff2 <= 128'd0;
        data_in_ff3 <= 128'd0;
        shift_val_ff1 <= 7'd0;
        shift_val_ff2 <= 7'd0;
        shift_val_ff3 <= 7'd0;
    end
    else begin
        data_in_ff1 <= data_in;
        data_in_ff2 <= data_in_ff1;
        data_in_ff3 <= data_in_ff2;
        shift_val_ff1 <= shift_val;
        shift_val_ff2 <= shift_val_ff1;
        shift_val_ff3 <= shift_val_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 128'd0;
    end
    else if (stage3) begin
        result <= (shift_val_ff3 == 7'd0) ? data_in_ff3 :
                  (shift_val_ff3 < 7'd128) ? data_in_ff3 << shift_val_ff3 :
                  128'd0;
    end
end

endmodule