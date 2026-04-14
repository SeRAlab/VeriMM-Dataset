module top_module(req0, req1, clk) ;input  req0, req1, clk;

wire  sb_gnt0, sb_gnt1;
reg    [1:0] sb_state;

assign  sb_gnt0 = sb_state[0];
assign  sb_gnt1 = sb_state[1];


always @(posedge clk)
begin

  if (req0 == 1'b1 && sb_state[1:0] != 2'b10) begin 
    sb_state[1:0] = 2'b01;
  end
  else if (req1 == 1'b1 && sb_state[1:0] != 2'b01) begin
    sb_state[1:0] = 2'b10;
  end
  else begin
    sb_state[1:0] = 2'b00;
  end

end

endmodule