module dff_set (
  input CLK, D, SET_B,
  output reg Q
);

  always @(posedge CLK) begin
    if (!SET_B) // Asynchronous set
      Q <= 0;
    else
      Q <= D;
  end

endmodule