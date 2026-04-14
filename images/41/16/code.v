module top_module(
        input clk, 
        input [7:0]keyboard,
        input home_on, attack_on,
        
        output reg video_home_on,video_attack_on 
    );integer state = 0;
    integer state_divider = 0;
	always @ (posedge clk) begin
	       state_divider = (state_divider + 1) % 2500000;
	end
    always @(posedge clk) begin
      if (state_divider==0) begin
        
        if (keyboard  == 8'h0D && video_home_on == 1) begin
            state = (state + 1)%2 ;
        end
      end
        
        
        
       
    end
    
    always @*
	case (state)
	   0: begin 
	       video_home_on = 1; 
	       video_attack_on =0; 
	       end
	   1:begin 
	       video_home_on = 0; 
	       video_attack_on =1; 
	       end
	
	endcase
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule