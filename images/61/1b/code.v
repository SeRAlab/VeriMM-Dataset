module top_module( clk, op, right, AI, BI, CI, CO, BCD, OUT, V, Z, N, HC, RDY );input clk;
	input right;
	input [3:0] op;		
	input [7:0] AI;
	input [7:0] BI;
	input CI;
	input BCD;		
	output [7:0] OUT;
	output CO;
	output V;
	output Z;
	output N;
	output HC;
	input RDY;

reg [7:0] OUT;
reg CO;
wire V;
wire Z;
reg N;
reg HC;

reg AI7;
reg BI7;
reg [8:0] temp_logic;
reg [7:0] temp_BI;
reg [4:0] temp_l;
reg [4:0] temp_h;
wire [8:0] temp = { temp_h, temp_l[3:0] };
wire adder_CI = (right | (op[3:2] == 2'b11)) ? 0 : CI;




always @*  begin
	case( op[1:0] )
	    2'b00: temp_logic = AI | BI;
	    2'b01: temp_logic = AI & BI;
	    2'b10: temp_logic = AI ^ BI;
	    2'b11: temp_logic = AI;
	endcase

	if( right )
	    temp_logic = { AI[0], CI, AI[7:1] };
end



always @* begin
	case( op[3:2] )
	    2'b00: temp_BI = BI;	
	    2'b01: temp_BI = ~BI;	
	    2'b10: temp_BI = temp_logic;	
	    2'b11: temp_BI = 0;		
	endcase	
end


wire HC9 = BCD & (temp_l[3:1] >= 3'd5);


wire CO9 = BCD & (temp_h[3:1] >= 3'd5);


wire temp_HC = temp_l[4] | HC9;



always @* begin
	temp_l = temp_logic[3:0] + temp_BI[3:0] + adder_CI;
	temp_h = temp_logic[8:4] + temp_BI[7:4] + temp_HC;
end


always @(posedge clk)
    if( RDY ) begin
	AI7 <= AI[7];
	BI7 <= temp_BI[7];
	OUT <= temp[7:0];
	CO  <= temp[8] | CO9;
	N   <= temp[7];
	HC  <= temp_HC;
    end

assign V = AI7 ^ BI7 ^ CO ^ N;
assign Z = ~|OUT;

endmodule