module top_module(
	input clock,
    input reset,
    input enable,
    output [7:0] rnd
    );reg [7:0] random, random_done;
reg [3:0] count; 

wire feedback = random[5] ^random[3] ^ random[4] ^ random[1];



always @ (posedge clock or negedge reset) begin
	if (!reset) begin
		random <= 8'd100; 
		count <= 0;
	end  else if(enable) begin
		random <= {random[6:0], feedback};
		count <= count + 1;

		if (count == 8)  begin
	  		count <= 0;
	  		random_done <= random; 
		end
	end
end
 
assign rnd = random_done;
 
endmodule