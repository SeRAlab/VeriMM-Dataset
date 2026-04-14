module top_module(
  input SI, CLK,
  output Q3, SO
);reg [3:0] shift_reg;
  reg [3:0] next_reg;
  wire [2:0] stage1_out;
  wire [2:0] stage2_out;
  wire [2:0] stage3_out;

  assign SO = shift_reg[3];
  assign Q3 = shift_reg[0];

  // Pipeline Stage 1
  always @ (posedge CLK) begin
    next_reg[0] <= SI;
    next_reg[1] <= shift_reg[0];
    next_reg[2] <= shift_reg[1];
    next_reg[3] <= shift_reg[2];
  end

  // Pipeline Stage 2
  always @ (posedge CLK) begin
    shift_reg[0] <= stage1_out[2];
    shift_reg[1] <= stage1_out[1];
    shift_reg[2] <= stage1_out[0];
    next_reg[0] <= shift_reg[3];
    next_reg[1] <= shift_reg[0];
    next_reg[2] <= shift_reg[1];
    next_reg[3] <= shift_reg[2];
  end

  // Pipeline Stage 3
  always @ (posedge CLK) begin
    shift_reg[0] <= stage2_out[2];
    shift_reg[1] <= stage2_out[1];
    shift_reg[2] <= stage2_out[0];
    next_reg[0] <= shift_reg[3];
    next_reg[1] <= shift_reg[0];
    next_reg[2] <= shift_reg[1];
    next_reg[3] <= shift_reg[2];
  end

  // Pipeline Stage 4
  always @ (posedge CLK) begin
    shift_reg[0] <= stage3_out[2];
    shift_reg[1] <= stage3_out[1];
    shift_reg[2] <= stage3_out[0];
    next_reg[0] <= shift_reg[3];
    next_reg[1] <= shift_reg[0];
    next_reg[2] <= shift_reg[1];
    next_reg[3] <= shift_reg[2];
  end

  // Pipeline Stage 1 Logic
  assign stage1_out[0] = next_reg[0];
  assign stage1_out[1] = next_reg[1];
  assign stage1_out[2] = next_reg[2];

  // Pipeline Stage 2 Logic
  assign stage2_out[0] = next_reg[1];
  assign stage2_out[1] = next_reg[2];
  assign stage2_out[2] = next_reg[3];

  // Pipeline Stage 3 Logic
  assign stage3_out[0] = next_reg[2];
  assign stage3_out[1] = next_reg[3];
  assign stage3_out[2] = SI;
endmodule