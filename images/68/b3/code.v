module top_module(
  // Inputs
  input drck1_i,
  input reset_i,
  input sel1_i,
  input shift_i,
  input tdi_i,

  // Outputs
  output reg [4:0] tdo1_o
);reg [4:0] counter;
  reg [4:0] shift_reg;
  reg shift_enable;

  // Counter logic
  always @(posedge drck1_i) begin
    if (reset_i) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end

  // Shift register logic
  always @(posedge drck1_i) begin
    if (sel1_i && shift_i) begin
      shift_reg <= {shift_reg[3:0], tdi_i};
      shift_enable <= 1;
    end else begin
      shift_enable <= 0;
    end
  end

  // Output logic
  always @(posedge drck1_i) begin
    if (shift_enable) begin
      tdo1_o <= shift_reg;
    end else begin
      tdo1_o <= counter;
    end
  end
endmodule