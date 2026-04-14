module top_module(
    input [31:0] startVal,          
    input reset,
    input enable,
    input clk,
    output reg [31:0] count
    );always @(posedge clk)
    begin
        if (reset == 1'b0)
            count <= 0;
        else if (count == {32{1'b0}}    )
            count <= startVal;
        else if (enable == 1'b1)    
            count <= count - 1'b1;
        else                        
            count <= startVal;
    end
    
endmodule