module top_module(Bin,Bout,Clk,Rst);input Bin;
  input Clk,Rst;
  output Bout;
   reg Bout;
  reg [1:0]State;
  parameter INIT=0,WAIT=1;
  always @(posedge Clk)
   begin
   if (Rst==1)
    begin
    case(State)
     INIT:
       begin
	  Bout<=1'b0;
        if(Bin==0)
         begin
          Bout<=1'b1;
         State<=WAIT;
         end
        else
          begin
           State<=INIT;
         end
       end
    WAIT:
      begin
         Bout<=1'b0;
        if(Bin==1)
         begin
           State<=INIT;
          end
         else
         begin
          State<=WAIT;
         end
      end
   default:
      begin
     Bout<=1'b0; 
        begin
        State<=INIT;
        end
      end
   endcase
   end
 else
  begin
   if(Rst==0)
    begin
    Bout<=1'b0;
    State<=INIT;
    end
   end
  end
endmodule