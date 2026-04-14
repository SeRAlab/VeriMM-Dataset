module eth_clockgen(Clk, Reset, Divider, MdcEn, MdcEn_n, Mdc);
parameter Tp=1;
input       Clk;              
input       Reset;            
input [7:0] Divider;          
output      Mdc;              
output      MdcEn;            
output      MdcEn_n;          
reg         Mdc;
reg   [7:0] Counter;
wire        CountEq0;
wire  [7:0] CounterPreset;
wire  [7:0] TempDivider;
assign TempDivider[7:0]   = (Divider[7:0]<2)? 8'h02 : Divider[7:0]; 
assign CounterPreset[7:0] = (TempDivider[7:0]>>1) -1;               
always @ (posedge Clk or posedge Reset)
begin
  if(Reset)
    Counter[7:0] <= #Tp 8'h1;
  else
    begin
      if(CountEq0)
        begin
          Counter[7:0] <= #Tp CounterPreset[7:0];
        end
      else
        Counter[7:0] <= #Tp Counter - 8'h1;
    end
end
always @ (posedge Clk or posedge Reset)
begin
  if(Reset)
    Mdc <= #Tp 1'b0;
  else
    begin
      if(CountEq0)
        Mdc <= #Tp ~Mdc;
    end
end
assign CountEq0 = Counter == 8'h0;
assign MdcEn = CountEq0 & ~Mdc;
assign MdcEn_n = CountEq0 & Mdc;
endmodule