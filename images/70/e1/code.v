module top_module(
IDATA1  ,	
IDATA2  ,	
IDATA3  ,	
IDATA4  ,	
IDATA5  ,	
IDATA6  ,	
SELECT  ,	
ODATA       
);parameter DATA_WIDTH = 32;


input   [DATA_WIDTH-1:0] 	IDATA1;
input   [DATA_WIDTH-1:0] 	IDATA2;
input   [DATA_WIDTH-1:0] 	IDATA3;
input   [DATA_WIDTH-1:0] 	IDATA4;
input   [DATA_WIDTH-1:0] 	IDATA5;
input   [DATA_WIDTH-1:0] 	IDATA6;
input   [2:0]               SELECT;


output reg  [DATA_WIDTH-1:0]    ODATA;




always @ (IDATA1 or IDATA2 or IDATA3 or IDATA4 or IDATA5 or IDATA6 or SELECT) begin
	case (SELECT)
		3'b000: ODATA = IDATA1;
		3'b001: ODATA = IDATA2;
		3'b010: ODATA = IDATA3;
		3'b011: ODATA = IDATA4;
		3'b100: ODATA = IDATA5;
		3'b101: ODATA = IDATA6;
		default: ODATA = IDATA1;
	endcase
end

endmodule