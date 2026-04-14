module top_module(
        input clk,
        input [1:0] world,
        input [11:0] botIcon,
        input video_on,
        input [11:0] firstscreen,
        output reg [11:0] drawIcon
    );parameter 
        BLACK = 12'b000000000000,
        WHITE = 12'b111111111111,
        GREEN = 12'b000011110000,
        RED   = 12'b111100000000,
        BLUE  = 12'b000000001111;
        
     always @(posedge clk) begin
        if (~video_on)
            drawIcon <= BLACK;          
        else if (botIcon)              
            drawIcon <= botIcon; 
    
    
        else begin
            case (world)
                2'b00: drawIcon    <= WHITE;    
                2'b01: drawIcon    <= BLACK;    
                2'b10: drawIcon    <= RED;    
                2'b11: drawIcon    <= GREEN;      
        endcase
     end  
     end
endmodule