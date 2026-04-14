module clock_switch8_basic( 
clk_o, 
rst0_i, clk0_i, rst1_i, clk1_i, rst2_i, clk2_i, rst3_i, clk3_i, 
rst4_i, clk4_i, rst5_i, clk5_i, rst6_i, clk6_i, rst7_i, clk7_i, 
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
input        rst4_i;
input        clk4_i;
input        rst5_i;
input        clk5_i;
input        rst6_i;
input        clk6_i;
input        rst7_i;
input        clk7_i;
input        enable;   
input  [2:0] select;   
output       clk_o;
reg    [1:0] ssync0;   
reg    [1:0] ssync1;
reg    [1:0] ssync2;
reg    [1:0] ssync3;
reg    [1:0] ssync4;
reg    [1:0] ssync5;
reg    [1:0] ssync6;
reg    [1:0] ssync7;
reg    [7:0] decode;   
always @( select or enable )
begin
          decode    = 8'h0;
 case( select )
 3'b000:  decode[0] = enable;
 3'b001:  decode[1] = enable;
 3'b010:  decode[2] = enable;
 3'b011:  decode[3] = enable;
 3'b100:  decode[4] = enable;
 3'b101:  decode[5] = enable;
 3'b110:  decode[6] = enable;
 3'b111:  decode[7] = enable;
 default: decode    = 8'h0;
 endcase
end
always @( posedge clk0_i or posedge rst0_i )
if( rst0_i )     ssync0 <= 2'b0;
else ssync0 <= { ssync0[0], ( decode[0] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk1_i or posedge rst1_i )
if( rst1_i )     ssync1 <= 2'b0;
else ssync1 <= { ssync1[0], (~ssync0[1] &
                              decode[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk2_i or posedge rst2_i )
if( rst2_i )     ssync2 <= 2'b0;
else ssync2 <= { ssync2[0], (~ssync0[1] &
                             ~ssync1[1] &
                              decode[2] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk3_i or posedge rst3_i )
if( rst3_i )     ssync3 <= 2'b0;
else ssync3 <= { ssync3[0], (~ssync0[0] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                              decode[3] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk4_i or posedge rst4_i )
if( rst4_i )     ssync4 <= 2'b0;
else ssync4 <= { ssync4[0], (~ssync0[0] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                              decode[4] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk5_i or posedge rst5_i )
if( rst5_i )     ssync5 <= 2'b0;
else ssync5 <= { ssync5[0], (~ssync0[1] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                              decode[5] &
                             ~ssync6[1] &
                             ~ssync7[1] ) }; 
always @( posedge clk6_i or posedge rst6_i )
if( rst6_i )     ssync6 <= 2'b0;
else ssync6 <= { ssync6[0], (~ssync0[1] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                              decode[6] &
                             ~ssync7[1] ) }; 
always @( posedge clk7_i or posedge rst7_i )
if( rst7_i )     ssync7 <= 2'b0;
else ssync7 <= { ssync7[0], (~ssync0[1] &
                             ~ssync1[1] &
                             ~ssync2[1] &
                             ~ssync3[1] &
                             ~ssync4[1] &
                             ~ssync5[1] &
                             ~ssync6[1] &
                              decode[7] ) }; 
wire gclk0 = ~ssync0[1] | clk0_i; 
wire gclk1 = ~ssync1[1] | clk1_i; 
wire gclk2 = ~ssync2[1] | clk2_i; 
wire gclk3 = ~ssync3[1] | clk3_i; 
wire gclk4 = ~ssync4[1] | clk4_i; 
wire gclk5 = ~ssync5[1] | clk5_i; 
wire gclk6 = ~ssync6[1] | clk6_i; 
wire gclk7 = ~ssync7[1] | clk7_i; 
wire clk_o =  gclk0 & gclk1 & gclk2 & gclk3 & gclk4 & gclk5 & gclk6 & gclk7;
endmodule