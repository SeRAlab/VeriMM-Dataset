module top_module(
input clk,reset,
output reg [3:0] counter
    );always @(posedge clk)   
begin  
    if(reset)
        counter <= 4'b0000;
    else if(counter != 4'b1111)
        counter <= counter + 1;
    else
        counter <= 4'b0000;        
end    
endmodule