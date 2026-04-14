module top_module(
			input wire [25:0] VGA_SCA_RGB_Str_i,	
            output wire      HSync,         		
            output wire      VSync,         		
            output wire      Red,   				
            output wire     Green, 					
            output wire      Blue,  				
            output wire [9:0] XCoord,          		
            output wire [9:0] YCoord,          		
            output wire      ActiveVideo			
         );`define Active 0:0
`define VS 1:1
`define HS 2:2
`define YC 12:3
`define XC 22:13
`define B 23:23
`define G 24:24
`define R 25:25
   
    assign HSync = VGA_SCA_RGB_Str_i[`HS];
    assign VSync = VGA_SCA_RGB_Str_i[`VS];
    assign ActiveVideo = VGA_SCA_RGB_Str_i[`Active];
	assign XCoord = VGA_SCA_RGB_Str_i[`XC];
	assign YCoord = VGA_SCA_RGB_Str_i[`YC];
	assign Red = VGA_SCA_RGB_Str_i[`R];
	assign Green = VGA_SCA_RGB_Str_i[`G];
	assign Blue = VGA_SCA_RGB_Str_i[`B];
	
 endmodule