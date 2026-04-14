module top_module(
	clk_i,
	
	reset_n_i,
	
	sclr_i,
	
	pix01_i,
	pix10_i,
	pix12_i,
	pix21_i,
	sin_i,
	cos_i,
	
	dv0_i,
	dv1_i,
	dv2_i,
 
	data_o
 );parameter DATA_WIDTH = 8;
parameter COEF_WIDTH = 9; 
 
input clk_i;
input reset_n_i;
input dv0_i;
input dv1_i;
input dv2_i;
input sclr_i;

input [DATA_WIDTH-1:0] pix01_i, pix10_i, pix12_i, pix21_i;
input [COEF_WIDTH-1:0] sin_i;
input [COEF_WIDTH-1:0] cos_i;

output [((COEF_WIDTH + DATA_WIDTH)+1):0] data_o;


reg signed [DATA_WIDTH:0] tmpsin;
reg signed [DATA_WIDTH:0] tmpcos;

reg signed [(COEF_WIDTH + DATA_WIDTH):0] multsin;		
reg signed [(COEF_WIDTH + DATA_WIDTH):0] multcos;

reg signed [((COEF_WIDTH + DATA_WIDTH)+1):0] finaladd;




wire signed [COEF_WIDTH-1:0] sin_wire;
wire signed [COEF_WIDTH-1:0] cos_wire;


always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		tmpsin <= {(DATA_WIDTH+1){1'b0}};
	else if (dv0_i)
		tmpsin <= pix21_i - pix01_i;
	else
		tmpsin <= tmpsin;

always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		tmpcos <= {(DATA_WIDTH+1){1'b0}};
	else if (dv0_i)
		tmpcos <= pix10_i - pix12_i; 
	else 
		tmpcos <= tmpcos;



	
		
			
			
		
	
		
			
			
		


assign sin_wire = sin_i;	
assign cos_wire = cos_i;	
		
always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		begin
			multsin <= {(COEF_WIDTH + DATA_WIDTH + 1){1'b0}};
			multcos <= {(COEF_WIDTH + DATA_WIDTH + 1){1'b0}};
		end
	else if (dv1_i)  
		begin
			multsin <= tmpsin * sin_wire;
			multcos <= tmpcos * cos_wire;
		end

		
always@(posedge clk_i or negedge reset_n_i)
	if (reset_n_i == 0)	
		begin
			finaladd <= {((COEF_WIDTH + DATA_WIDTH)+2){1'b0}};
		end
	else if (dv2_i) 
		begin 
			finaladd <= multsin + multcos;
		end

assign data_o = (finaladd > 0) ? finaladd : (~finaladd + 1'b1);		

		
endmodule