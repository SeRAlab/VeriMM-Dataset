module current_ctrl (
  input ctrl,
  output reg I
);

parameter I_src = 0.5; // current provided by the source (in Amperes)
parameter I_sink = 0.3; // current absorbed by the sink (in Amperes)

// implement current source and sink behavior
always @(*) begin
  if (ctrl) begin
    I = I_src;
  end else begin
    I = -I_sink;
  end
end

endmodule