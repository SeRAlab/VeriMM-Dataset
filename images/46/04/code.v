module top_module(
  input Reset_n_i,
  input Clk_i,
  input ResetSig_i,
  input Preset_i,
  input Enable_i,
  input Direction_i,
  input [15:0] PresetVal_i,
  output reg [15:0] D_o,
  output reg Overflow_o,
  output reg Zero_o
);reg [15:0] count;

  always @(posedge Clk_i) begin
    if (!Reset_n_i) begin
      count <= 16'd0;
      Overflow_o <= 1'b0;
      Zero_o <= 1'b1;
    end
    else if (ResetSig_i) begin
      count <= 16'd0;
      Overflow_o <= 1'b0;
      Zero_o <= 1'b1;
    end
    else if (Preset_i) begin
      count <= PresetVal_i;
      Overflow_o <= (Direction_i && (PresetVal_i == 16'hFFFF)) || (!Direction_i && (PresetVal_i == 16'h0000));
      Zero_o <= (PresetVal_i == 16'h0000);
    end
    else if (Enable_i) begin
      if (Direction_i) begin
        if (count == 16'hFFFF) begin
          count <= 16'h0000;
          Overflow_o <= 1'b1;
          Zero_o <= 1'b0;
        end
        else begin
          count <= count + 1;
          Overflow_o <= 1'b0;
          Zero_o <= (count == 16'h0000);
        end
      end
      else begin
        if (count == 16'h0000) begin
          count <= 16'hFFFF;
          Overflow_o <= 1'b0;
          Zero_o <= 1'b1;
        end
        else begin
          count <= count - 1;
          Overflow_o <= (count == 16'hFFFF);
          Zero_o <= 1'b0;
        end
      end
    end
    D_o <= count;
  end

endmodule