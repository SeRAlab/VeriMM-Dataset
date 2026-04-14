module top_module(clk, SW0,SW1, sig_sine, sig_square, sig);input clk;                  
    input [1:0] SW0;
	 input [1:0] SW1;
	 input [11:0] sig_sine;	 
    input [11:0] sig_square;    
    
    output reg [23:0] sig = {4'b0011,4'b1111,16'b0000}; 
    
    always @(posedge clk)
    begin
        
        if (SW0 == 1) begin
            sig[15:4] = sig_square;
        end       
        if (SW1 == 1) begin
            sig[15:4] = sig_sine;
        end       
        
    end

endmodule