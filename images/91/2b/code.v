module top_module(OUT_FLAG,
    IN_FLAG,
    SET,
    LD,
    CLR,
    CLK);output reg OUT_FLAG; // Changed to reg type
  input IN_FLAG;
  input SET;
  input LD;
  input CLR;
  input CLK;

  wire OUT_FLAG_i_1_n_0;

  assign OUT_FLAG_i_1_n_0 = (SET) ? 1'b1 : (CLR) ? 1'b0 : (LD) ? IN_FLAG : OUT_FLAG;

  always @(posedge CLK or posedge CLR) begin
    if (CLR)
      OUT_FLAG <= 1'b0;
    else
      OUT_FLAG <= OUT_FLAG_i_1_n_0;
  end
endmodule