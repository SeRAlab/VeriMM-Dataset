module top_module(
    input [7:0] bin,
    output reg [11:0] bcd
);reg [3:0] i;   
     
    
    always @(bin) begin
        bcd = 0; 
        for (i = 4'd0; i < 4'd8; i = i + 4'd1) begin 
            bcd = {bcd[10:0], bin[7-i]}; 
                
            
            if (i < 4'd7 && bcd[3:0] > 4'd4) 
                bcd[3:0] = bcd[3:0] + 4'd3;
            if (i < 4'd7 && bcd[7:4] > 4'd4)
                bcd[7:4] = bcd[7:4] + 4'd3;
            if (i < 4'd7 && bcd[11:8] > 4'd4)
                bcd[11:8] = bcd[11:8] + 4'd3;  
        end
    end     

endmodule