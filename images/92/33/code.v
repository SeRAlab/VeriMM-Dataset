module top_module(input [15:0] pi, input sir, clk, rst, shiftEnable, Lden, output reg [15:0] sout, output sol);always @ ( posedge clk , posedge rst ) begin
    if(rst) sout <= 16'b0;
    else
      if(Lden) sout<=pi;
      else
        if(shiftEnable) sout <= {sout[14:0],sir};
        else sout <= sout;
  end
  assign sol = sout[15];endmodule