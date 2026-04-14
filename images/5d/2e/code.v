module top_module(
    input [6:0]efect,
    output reg efect0,
    output reg efect1,
    output reg efect2,
    output reg efect3,
    output reg efect4,
    output reg efect5 
    );always @(efect) begin
case(efect)
     			7'd48: 	begin			
						efect0 =1'b1;
						efect1 =1'b0;
						efect2 =1'b0;
						efect3 =1'b0;
						efect4 =1'b0;
						efect5 =1'b0;
						
						
							end
					
     			7'd49: 	begin			
						efect0 =1'b0;
						efect1 =1'b1;
						efect2 =1'b0;
						efect3 =1'b0;
						efect4 =1'b0;
						efect5 =1'b0;
						
						
							end
			7'd50: 	begin			
						efect0 =1'b0;
						efect1 =1'b0;
						efect2 =1'b1;
						efect3 =1'b0;
						efect4 =1'b0;
						efect5 =1'b0;
						
						
							end	
			7'd51: 	begin			
						efect0 =1'b0;
						efect1 =1'b0;
						efect2 =1'b0;
						efect3 =1'b1;
						efect4 =1'b0;
						efect5 =1'b0;
						
						
							end
			7'd52: 	begin			
						efect0 =1'b0;
						efect1 =1'b0;
						efect2 =1'b0;
						efect3 =1'b0;
						efect4 =1'b1;
						efect5 =1'b0;
						
						
							end
			7'd53: 	begin			
						efect0 =1'b0;
						efect1 =1'b0;
						efect2 =1'b0;
						efect3 =1'b0;
						efect4 =1'b0;
						efect5 =1'b1;
						
						
							end
			
							
			default:
					begin
						efect0 =1'b1;
						efect1 =1'b0;
						efect2 =1'b0;
						efect3 =1'b0;
						efect4 =1'b0;
						efect5 =1'b0;
						
						
					end
		endcase
		end
endmodule