module gated_d_latch (
  input D, G, CLK,
  output Q
);

  reg Q_int;
  
  always @(posedge CLK) begin
    if (G) begin
      Q_int <= D;
    end
  end
  
  assign Q = Q_int;
  
endmodule