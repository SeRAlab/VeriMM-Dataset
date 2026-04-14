module top_module(clk,
				   trigWrite,
				   clrFifo,
				   sclr,
				   writeReq);input				clk;
input				trigWrite;		
input				clrFifo;			

output			sclr;				
output			writeReq;		

reg		[1:0]	status;			
reg				prevTrigWrite;	
reg				sclr;				
reg				writeReq;		

always	@(posedge clk)
	case (status)
		2'b00:	
			begin
				if (trigWrite != prevTrigWrite)
					begin
						if (clrFifo)	sclr	<= 1;
						prevTrigWrite			<= trigWrite;
						status					<= 2'b01;
					end
				else	status	<= 2'b00;	
			end
		2'b01:	
			begin
				sclr		<= 0;
				writeReq	<= 1;
				status		<= 2'b10;
			end
		2'b10:	
			begin
				writeReq	<= 0;
				status		<= 2'b00;	
			end
		default:	status	<= 2'b00;
	endcase

endmodule