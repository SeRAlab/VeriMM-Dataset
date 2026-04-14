module top_module(
  input         Transmit_CLK,                
  input         RX_Gate,                    
  input   [7:0] EmitDelay,                  
  input   [5:0] Emit_Width,                
  output  reg   TXP,
  output  reg   TXN
  );reg  [6:0]  Emit_Counter;
  
  reg  [6:0]  Delay_Counter;
    
	 
  always @(posedge Transmit_CLK or negedge RX_Gate)
  begin
  	if(~RX_Gate) 
	 begin
  		Emit_Counter  <= 7'd0;
  		Delay_Counter <= 8'd0;
  		TXP           <= 1'b1;
  		TXN           <= 1'b1;
  	end
  	else
  		begin
  		  if(Delay_Counter < EmitDelay[6:0] ) begin
  				Delay_Counter <= Delay_Counter + 1'b1;
  				TXP           <= 1'b1;
				TXN           <= 1'b1;
		  end
  		  else begin
			if(~EmitDelay[7]) begin  
				if(Emit_Counter <Emit_Width)begin                        
					TXP <= 1'b1;
					TXN <= 1'b0;
					Emit_Counter <= Emit_Counter + 1'b1;
				end
				else if(Emit_Counter <{Emit_Width,1'b0})begin           
					TXP <= 1'b0;
					TXN <= 1'b1;
					Emit_Counter <= Emit_Counter + 1'b1;
				end		
				
				else if(Emit_Counter <({Emit_Width,2'b0}+Emit_Width))begin             
					TXP <= 1'b0;
					TXN <= 1'b0;
					Emit_Counter <= Emit_Counter + 1'b1;
				end
				
				else begin                                               
					TXP <= 1'b1;
					TXN <= 1'b1;
				end
				
				
			end
			else begin              
				TXP <= 1'b1;
				TXN <= 1'b1;
			end


		  end
	   end
  end

    
endmodule