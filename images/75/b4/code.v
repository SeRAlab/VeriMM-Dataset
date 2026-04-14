module top_module(
    input wire clk,
    input wire reset,
    output wire out,
    input wire [7:0] level
    );reg [7:0] counter;

    always @(posedge clk) begin
	if(reset) begin
	counter <=0;								
	end else begin
	counter <= counter + 1'b1;
	
	end	    
    end

	assign out = counter < level;
endmodule