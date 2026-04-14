module top_module(
  input CLK,
  input LOAD,
  input SER_IN,
  input [31:0] PAR_IN,
  output SER_OUT
);reg [31:0] shift_reg;

  always @(posedge CLK) begin
    if (LOAD) begin
      shift_reg <= PAR_IN;
    end else begin
      shift_reg <= {shift_reg[30:0], SER_IN};
    end
  end

  assign SER_OUT = shift_reg[31];

endmodule