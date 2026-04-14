module top_module(  clk, r, enable, speed,out
    );parameter WIDTH = 7; 
    input [WIDTH-1:0]speed;
    input wire clk, r, enable;
    output reg [WIDTH-1:0] out = 0;
    
    always @(posedge clk) begin
        if (r) out <= 0;
        else if(enable == 1) out  <= (speed > out)? speed : out;
    end
    
    
endmodule