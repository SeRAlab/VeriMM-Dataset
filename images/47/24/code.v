module top_module(
          DADDR_IN,            
          DCLK_IN,             
          DEN_IN,              
          DI_IN,               
          DWE_IN,              
          VAUXP12,             
          VAUXN12,
          VAUXP13,             
          VAUXN13,
          DO_OUT,              
          DRDY_OUT,            
          ALARM_OUT,           
          VP_IN,               
          VN_IN);input [6:0] DADDR_IN;
          input DCLK_IN;
          input DEN_IN;
          input [15:0] DI_IN;
          input DWE_IN;
          input VAUXP12;
          input VAUXN12;
          input VAUXP13;
          input VAUXN13;
          input VP_IN;
          input VN_IN;

          output reg [15:0] DO_OUT;
          output reg DRDY_OUT;
          output ALARM_OUT;
			 
			 
			 always @(posedge DCLK_IN)
			 begin
			     DO_OUT   <=   16'h0000;
				  DRDY_OUT <=   DEN_IN;
			 end

        

endmodule