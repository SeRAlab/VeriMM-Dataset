module top_module(
    input clk,
    input reset_n,
    output [6:0] o_cnt,
    output [6:0] o_cnt_always
    );reg [6:0] cnt;  
	always @(posedge clk or negedge reset_n) begin
	    if(!reset_n) begin
	        cnt <= 0;  
	    end else if (cnt < 100) begin
	        cnt <= cnt + 1; 
	    end
	    
	end
	assign o_cnt = cnt;

	reg [6:0] cnt_always;  
	always @(posedge clk or negedge reset_n) begin
	    if(!reset_n) begin
	        cnt_always <= 0;  
	    end else if (cnt_always == 100-1) begin
	        cnt_always <= 0; 
	    end else begin
	        cnt_always <= cnt_always + 1; 
		end
	end
	assign o_cnt_always = cnt_always;

endmodule