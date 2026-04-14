module top_module(idata,iaddr);output [15:0] idata;
input  [15:0] iaddr;

reg    [15:0] idata;

always @(iaddr[5:1])
  case(iaddr[5:1])

	0: idata={4'd6,3'd0,3'd2,7'd1};       
	1: idata={4'd6,3'd0,3'd3,7'b1110000}; 
	2: idata={4'd6,3'd0,3'd4,7'd16};      
	3: idata={4'd6,3'd0,3'd5,7'b1111110}; 
	4: idata={4'd4,3'd4,3'd5,7'd6};       
	5: idata={4'd6,3'd0,3'd5,7'b0110000}; 
	6: idata={4'd4,3'd4,3'd5,7'd8};       
	                                
	7: idata={4'd3,3'd3,3'd5,7'd0};       
	8: idata={4'd7,3'd5,3'd5,7'd1};  
	9: idata={4'd5,3'd5,3'd0,7'd2};       
	10: idata={4'd3,3'd4,3'd5,7'd8};      
	11: idata={4'd8,13'd13};              
		                            
	12: idata={4'd3,3'd4,3'd5,7'd6};      
	                                
	13: idata={4'd4,3'd3,3'd5,7'd10};     
	14: idata={4'd8,13'd7};               
    default: idata=0;
  endcase
  
endmodule