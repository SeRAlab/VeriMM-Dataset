module top_module(
    input Reset_n_i,
    input Clk_i,
    input Preset_i,
    input Enable_i,
    input Direction_i,
    input [15:0] PresetVal_i,
    output reg [15:0] Count_o,
    output reg Zero_o
);always @ (posedge Clk_i) begin
        if (Reset_n_i == 0) begin
            Count_o <= 16'd0;
            Zero_o <= 1'b1;
        end else if (Preset_i) begin
            Count_o <= PresetVal_i;
            Zero_o <= (PresetVal_i == 16'd0);
        end else if (Enable_i) begin
            if (Direction_i) begin
                Count_o <= Count_o + 16'd1;
            end else begin
                Count_o <= Count_o - 16'd1;
            end
            Zero_o <= (Count_o == 16'd0);
        end
    end

endmodule