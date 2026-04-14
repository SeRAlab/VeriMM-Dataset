module top_module(
	input [2:0] SW,      
	input [1:0] KEY,     
	output reg [2:0] LEDR);wire clk = KEY[0];
    wire L = KEY[1];
    wire [2:0] d = (L)?SW:{LEDR[1]^LEDR[2],LEDR[0],LEDR[2]};
    
    always @(posedge clk)begin
            LEDR	<=	d;
    end

endmodule