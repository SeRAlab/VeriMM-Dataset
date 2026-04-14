module top_module(
    input wire		iClock,			
    input wire		iReset,
    input wire		iOsc262k,		

    input wire [4:0] iOut1,   	
    input wire [4:0] iOut2,	
    input wire [4:0] iOut3,	
    input wire [4:0] iOut4,	

    input wire [7:0] iNR50,   	
    input wire [7:0] iNR51,   	

    output reg [4:0] 	oSO1, 	
    output reg [4:0] 	oSO2, 	 

    output wire [1:0]	oChSel,
    output wire			oChClk
  );reg [7:0] rNR50, rNR51;
reg [4:0] rSO1_PRE, rSO2_PRE;
reg rSer_clk; 			
reg [1:0] rSer_sel; 		



always @ (posedge iClock) begin
	if (iReset) begin
		rNR50 <= iNR50;
		rNR51 <= iNR51;
		rSer_sel <= 2'b0;
		rSer_clk <= 1'b0;

		rSO1_PRE <= 5'd15;
		rSO2_PRE <= 5'd15;		

	end
end


always @ (posedge iOsc262k) begin
		rSer_clk <= ~rSer_clk; 	
		rSer_sel <= (~rSer_clk) ? rSer_sel + 1 : rSer_sel;
end


always @ (*) begin

	case (rSer_sel)
		2'd0: begin
			rSO1_PRE = (rNR51[0]) ? iOut1 : 5'd15;
			rSO2_PRE = (rNR51[4]) ? iOut1 : 5'd15; 
		end
		2'd1: begin
			rSO1_PRE = (rNR51[1]) ? iOut2 : 5'd15;
			rSO2_PRE = (rNR51[5]) ? iOut2 : 5'd15;
		end
		2'd2: begin
			rSO1_PRE = (rNR51[2]) ? iOut3 : 5'd15;
			rSO2_PRE = (rNR51[6]) ? iOut3 : 5'd15;
		end
		2'd3: begin
			rSO1_PRE = (rNR51[3]) ? iOut4 : 5'd15;
			rSO2_PRE = (rNR51[7]) ? iOut4 : 5'd15;
		end
		default: begin
			rSO1_PRE = 5'dX;
			rSO2_PRE = 5'dX;
		end
	endcase
	
	oSO1 = rSO1_PRE >> (3'd7-rNR50[2:0]);
	oSO2 = rSO1_PRE >> (3'd7-rNR50[6:4]);	

end

assign oChSel = rSer_sel;
assign oChClk = rSer_clk;

endmodule