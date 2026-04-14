module clock_switch2_basic( 
clk_o, 
rst0_i, clk0_i, rst1_i, clk1_i, enable, select
);
input     rst0_i;
input     clk0_i;
input     rst1_i;
input     clk1_i;
input     enable;  
input     select;  
output    clk_o;
wire      sel0 = ~select & enable;
wire      sel1 =  select & enable;
reg [1:0] ssync0; 
reg [1:0] ssync1;
always @( posedge clk0_i or posedge rst0_i)
if( rst0_i )
     ssync0 <=   2'b0;
else ssync0 <= { ssync0[0] , (sel0 & ~ssync1[1] ) }; 
always @( posedge clk1_i or posedge rst1_i)
if( rst1_i )
     ssync1 <=   2'b0;
else ssync1 <= { ssync1[0] , (sel1 & ~ssync0[1] ) }; 
wire gclk0  = ~ssync0[1] | clk0_i; 
wire gclk1  = ~ssync1[1] | clk1_i; 
wire clk_o =   gclk0 & gclk1;      
endmodule