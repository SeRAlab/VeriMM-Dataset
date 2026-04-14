module top_module(
  input Reset_n_i,
  input Clk_i,
  input ResetSig_i,
  input Preset_i,
  input Enable_i,
  input Direction_i,
  input [15:0] PresetValH_i,
  input [15:0] PresetValL_i,
  output reg [15:0] DH_o,
  output reg [15:0] DL_o,
  output reg Overflow_o,
  output reg Zero_o
);reg [32:0] Value;

  always @(negedge Reset_n_i or posedge Clk_i)
  begin
    if (!Reset_n_i)
    begin
      Value   <= 'd0;
      DH_o    <= 'd0;
      DL_o    <= 'd0;
      Overflow_o <= 1'b0;
      Zero_o  <= 1'b1;
    end
    else
    begin
      if (ResetSig_i)
      begin
        Value <= 'd0;
        DH_o  <= 'd0;
        DL_o  <= 'd0;
        Overflow_o <= 1'b0;
        Zero_o <= 1'b1;
      end
      else if (Preset_i)
      begin
        Value <= {1'b0, PresetValH_i, PresetValL_i};
        DH_o  <= PresetValH_i;
        DL_o  <= PresetValL_i;
        Overflow_o <= 1'b0;
        Zero_o <= (Value[31:0] == 'd0 ? 1'b1 : 1'b0);
      end
      else if (Enable_i)
      begin
        if (!Direction_i)
          Value <= {1'b0, Value[31:0]} + 1'b1;
        else
          Value <= {1'b0, Value[31:0]} - 1'b1;

        DH_o  <= Value[31:16];
        DL_o  <= Value[15:0];
        Overflow_o <= (Value[32] == 1'b1 ? 1'b1 : 1'b0);
        Zero_o <= (Value[31:0] == 'd0 ? 1'b1 : 1'b0);
      end
    end
  end

endmodule