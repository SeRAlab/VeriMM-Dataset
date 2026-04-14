module top_module(clk,rst,start,q);input clk, rst, start;
output [15:0]q;
reg [15:0]lfsr;
always @(posedge clk)
  begin
    if(rst==0)
      begin
        lfsr<=16'hffff;
      end
    else
      begin
        if(start==1)
          begin
            lfsr[0]<=lfsr[1]^lfsr[2]^lfsr[4]^lfsr[15];
            lfsr[15:1]<=lfsr[14:0];
          end
        else
          begin
            lfsr<=16'hffff;
          end
      end
  end
assign q=lfsr;
endmodule