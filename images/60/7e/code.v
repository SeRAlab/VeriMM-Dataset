module top_module(
    input x,
    input y,
    input s,
    output reg m
    );always @*
	begin
          if(s==0)
             m=y;
          else
             m=x;
	end

endmodule