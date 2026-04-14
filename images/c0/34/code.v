module clock_switch4_basic( 
clk_o, 
rst0_i, clk0_i, rst1_i, clk1_i, rst2_i, clk2_i, rst3_i, clk3_i, 
enable, select
);
input        rst0_i;
input        clk0_i;
input        rst1_i;
input        clk1_i;
input        rst2_i;
input        clk2_i;
input        rst3_i;
input        clk3_i;
input        enable;   
input  [1:0] select;   
output       clk_o;
reg    [1:0] ssync0;   
reg    [1:0] ssync1;
reg    [1:0] ssync2;
reg    [1:0] ssync3;
reg    [3:0] decode;   
always @( select or enable )
begin
          decode    = 4'h0;
 case( select )
 2'b00:   decode[0] = enable;
 2'b01:   decode[1] = enable;
 2'b10:   decode[2] = enable;
 2'b11:   decode[3] = enable;
 default: decode    = 4'h0;
 endcase
end
always @( posedge clk0_i or posedge rst0_i )
if( rst0_i )
     ssync0 <=   2'b0;
else ssync0 <= { ssync0[0], ( decode[0] & ~ssync1[1] & ~ssync2[1] & ~ssync3[1] ) }; 
always @( posedge clk1_i or posedge rst1_i )
if( rst1_i )
     ssync1 <=   2'b0;
else ssync1 <= { ssync1[0], (~ssync0[1] &  decode[1] & ~ssync2[1] & ~ssync3[1] ) }; 
always @( posedge clk2_i or posedge rst2_i )
if( rst2_i )
     ssync2 <=   2'b0;
else ssync2 <= { ssync2[0], (~ssync0[1] & ~ssync1[1] &  decode[2] & ~ssync3[1] ) }; 
always @( posedge clk3_i or posedge rst3_i )
if( rst3_i )
     ssync3 <=   2'b0;
else ssync3 <= { ssync3[0], (~ssync0[1] & ~ssync1[1] & ~ssync2[1] &  decode[3] ) }; 
wire gclk0 = ~ssync0[1] | clk0_i; 
wire gclk1 = ~ssync1[1] | clk1_i; 
wire gclk2 = ~ssync2[1] | clk2_i; 
wire gclk3 = ~ssync3[1] | clk3_i; 
wire clk_o =  gclk0 & gclk1 & gclk2 & gclk3; 
endmodule