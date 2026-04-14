module clock_switch3_basic( 
clk_o, 
rst0_i, clk0_i, rst1_i, clk1_i, rst2_i, clk2_i, enable, select
);
input        rst0_i;
input        clk0_i;
input        rst1_i;
input        clk1_i;
input        rst2_i;
input        clk2_i;
input        enable;   
input  [1:0] select;   
output       clk_o;
reg    [1:0] ssync0;   
reg    [1:0] ssync1;
reg    [1:0] ssync2;
reg    [2:0] decode;   
always @( select or enable )
begin
          decode    = 3'b000;
 case( select )
 2'b00:   decode[0] = enable;
 2'b01:   decode[1] = enable;
 2'b10:   decode[2] = enable;
 2'b11:   decode[2] = enable; 
 default: decode    = 3'b000;
 endcase
end
always @( posedge clk0_i or posedge rst0_i )
if( rst0_i )
     ssync0 <=   2'b0;
else ssync0 <= { ssync0[0], ( decode[0] & ~ssync1[1] & ~ssync2[1] ) }; 
always @( posedge clk1_i or posedge rst1_i )
if( rst1_i )
     ssync1 <=   2'b0;
else ssync1 <= { ssync1[0], (~ssync0[1] &  decode[1] & ~ssync2[1] ) }; 
always @( posedge clk2_i or posedge rst2_i )
if( rst2_i )
     ssync2 <=   2'b0;
else ssync2 <= { ssync2[0], (~ssync0[1] & ~ssync1[1] &  decode[2] ) }; 
wire gclk0 = ~ssync0[1] | clk0_i; 
wire gclk1 = ~ssync1[1] | clk1_i; 
wire gclk2 = ~ssync2[1] | clk2_i; 
wire clk_o =  gclk0 & gclk1 & gclk2; 
endmodule