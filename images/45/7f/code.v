module top_module(ovf, b, eq, leds);input ovf, b, eq;
output [2:0] leds;

reg [2:0] leds;

always @(ovf, b, eq)
begin
    if(ovf)
        leds[0] = 1;
    else
        leds[0] = 0;
    
    if(b)
        leds[1] = 1;
    else
        leds[1] = 0;
        
    if(eq)
        leds[2] = 1;
    else
        leds[2] = 0;
end
endmodule