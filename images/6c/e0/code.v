module top_module(
    input clk,
    input rst,
    output reg [2:0] Q
    );always @ (posedge(clk))   
begin
    if (rst == 3'b111)
        
        Q <= 3'b0;
    else
        
        Q <= Q + 1'b1;
end
 
endmodule