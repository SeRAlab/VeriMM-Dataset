module top_module(
    input [3:0] flag,
    output reg  [11:0] overflow,
    output reg  [11:0] carry,
    output reg  [11:0] zero,
    output reg  [11:0] negative
     );always @(*) begin
    if (flag[3]==1'b1) 
        overflow= 12'h0F0;
        
    else
        overflow= 12'h000;
    end
always @(*) begin
        if (flag[2]==1'b1) 
            carry= 12'h0F0;
            
        else
            carry= 12'h000;
        end
always @(*) begin
            if (flag[1]==1'b1) 
                zero= 12'h0F0;
                
            else
                zero= 12'h000;
            end
always @(*) begin
                if (flag[0]==1'b1) 
                    negative= 12'h0F0;
                    
                else
                    negative= 12'h000;
                end              
endmodule