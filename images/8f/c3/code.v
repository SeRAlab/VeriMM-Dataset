module top_module(xin, yin, zin, xout, yout, zout, clk);input[29 - 1:0] xin; 
    input[29 - 1:0] yin; 
    input[29 - 1:0] zin; 
    output[29 - 1:0] xout; 
    wire[29 - 1:0] xout;
    output[29 - 1:0] yout; 
    wire[29 - 1:0] yout;
    output[29 - 1:0] zout; 
    wire[29 - 1:0] zout;
    input clk; 

    reg[29 - 1:0] bufferx0; 
    reg[29 - 1:0] bufferx1; 
    reg[29 - 1:0] buffery0; 
    reg[29 - 1:0] buffery1; 
    reg[29 - 1:0] bufferz0; 
    reg[29 - 1:0] bufferz1; 

    assign xout = bufferx1 ;
    assign yout = buffery1 ;
    assign zout = bufferz1 ;

    always @(posedge clk)
    begin
       bufferx0 <= xin ; 
       buffery0 <= yin ; 
       bufferz0 <= zin ; 

       bufferx1 <= bufferx0 ; 
       buffery1 <= buffery0 ; 
       bufferz1 <= bufferz0 ; 
    end 
 endmodule