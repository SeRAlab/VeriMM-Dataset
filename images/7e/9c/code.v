module top_module(
    input sw0,
    input sw1,
    input sw2,
    input reset,
	 input clk,
    output reg R,
    output reg G,
    output reg B,
    output reg hSync,
    output reg vSync
    );wire pxlclk;
wire[9:0] col;
wire[8:0] row;
wire col0;
wire row0;
wire act;

wire hSync0;
wire vSync0;

reg [16:0] xPixCounter;
reg [5:0] yPixCounter;
reg [5:0] xSuperPixCounter;
reg [4:0] ySuperPixCounter;


always @(posedge clk) 
begin
    hSync <= hSync0;
    vSync <= vSync0;
	 
	 
    if( act ) begin
	 
		R<= sw0;
		B<= sw1;
		G<= sw2;
		
	 





















			
	 end
	 else 
	 begin 
		B <= 0;
		G <= 0;
		R <= 0;
    end
	 
	 if(reset)
		begin
		xPixCounter <= 0;
		xSuperPixCounter <= 0;
		yPixCounter <= 0;
		ySuperPixCounter <= 0;
		
		end
	








































































	 
end

endmodule