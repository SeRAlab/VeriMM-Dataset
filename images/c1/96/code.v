module dbg_sync_clk1_clk2 (clk1, clk2, reset1, reset2, set2, sync_out);
parameter   Tp = 1;
input   clk1;
input   clk2;
input   reset1;
input   reset2;
input   set2;
output  sync_out;
reg     set2_q;
reg     set2_q2;
reg     set1_q;
reg     set1_q2;
reg     clear2_q;
reg     clear2_q2;
reg     sync_out;
wire    z;
assign z = set2 | set2_q & ~clear2_q2;
always @ (posedge clk2 or posedge reset2)
begin
  if(reset2)
    set2_q <=#Tp 1'b0;
  else
    set2_q <=#Tp z;
end
always @ (posedge clk2 or posedge reset2)
begin
  if(reset2)
    set2_q2 <=#Tp 1'b0;
  else
    set2_q2 <=#Tp set2_q;
end
always @ (posedge clk1 or posedge reset1)
begin
  if(reset1)
    set1_q <=#Tp 1'b0;
  else
    set1_q <=#Tp set2_q2;
end
always @ (posedge clk1 or posedge reset1)
begin
  if(reset1)
    set1_q2 <=#Tp 1'b0;
  else
    set1_q2 <=#Tp set1_q;
end
always @ (posedge clk2 or posedge reset2)
begin
  if(reset2)
    clear2_q <=#Tp 1'b0;
  else
    clear2_q <=#Tp set1_q2;
end
always @ (posedge clk2 or posedge reset2)
begin
  if(reset2)
    clear2_q2 <=#Tp 1'b0;
  else
    clear2_q2 <=#Tp clear2_q;
end
always @ (posedge clk1 or posedge reset1)
begin
  if(reset1)
    sync_out <=#Tp 1'b0;
  else
    sync_out <=#Tp set1_q2;
end
endmodule