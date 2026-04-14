module top_module(input [4:0]Ra, 
					input [4:0]Rb, 
					input [4:0]Rw, 
					input [31:0]Bw,
					input clk,     
					input Regwr,   
					output reg [31:0]Ba,
					output reg [31:0]Bb,
					input reset);(* keep = "true" *)	reg [31:0]rf[0:31]; 

   integer i;
   always@(posedge clk, negedge reset) begin 
                          if (reset == 0) for (i=0; i<32; i=i+1) rf[i] <= 32'h0;
                          else if(Regwr == 1 && Rw != 0)  rf[Rw] <= Bw;         
                          end 


	always @(*) begin
	               Ba <= rf[Ra];
	               Bb <= rf[Rb];
	            end
	            

    
endmodule