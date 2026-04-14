module top_module(input clk,
	    
	    input [19:0]     p1_addr,
	    input [7:0]      p1_data,
            output [7:0] p1_data_out, 
	    input            p1_we,
            input            p1_re,

	    input [19:0]     p2_addr,
	    output [7:0] p2_data);reg [7:0] 		 mem[0:153600-1];
   assign p1_data_out = p1_re?mem[p1_addr]:0;
   assign p2_data = mem[p2_addr];

   always @(posedge clk)
     begin
	if (p1_we) begin
	   mem[p1_addr] <= p1_data;
	end
     end

endmodule