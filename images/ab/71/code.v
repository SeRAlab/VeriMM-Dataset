module top_module(
    input wire Clk,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg [1:0] obXLOn,
    input wire onCollision_obXL
    );parameter Bupper = 170;
    parameter Blower = 190;
    parameter Bleft = 271;
    parameter Bright = 291;
  
    always @(posedge Clk) 
        begin
            if(Bupper <= y && y <= Blower && Bleft <= x && x <= Bright) 
                begin
                    red <= 8'd0;
                    green <= 8'd0;
                    blue <= 8'd255;
                    obXLOn<= 1;
                end
             else
                obXLOn <= 0;
                
             if(onCollision_obXL == 1)
                obXLOn <= 0;
        end
        
endmodule