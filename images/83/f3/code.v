module top_module(
    
  input rst,	
  input enb,	
  input dir,	
  input clk,	
  output reg [7:0] count	
    );always @ (posedge clk)
  begin
  if (rst)
    begin
    count<=0;
    end
  else
    begin
    if (enb)
      begin
      if (dir)
        begin
        count <= count +1;
        end
      else
        begin
        count <= count -1;
        end
      end
    else
      begin
      count <= count;
      end
    end
  end	
endmodule