module top_module(
  // inputs:
  free2,
  free3,
  tm_count,

  // outputs:
  fifowp_inc
);output  [3:0] fifowp_inc;
  input   free2;
  input   free3;
  input   [1:0] tm_count;

  reg [3:0] fifowp_inc;

  always @*
  begin
    if (free3 && (tm_count == 3))
      fifowp_inc = 3;
    else if (free2 && (tm_count >= 2))
      fifowp_inc = 2;
    else if (tm_count >= 1)
      fifowp_inc = 1;
    else
      fifowp_inc = 0;
  end

endmodule