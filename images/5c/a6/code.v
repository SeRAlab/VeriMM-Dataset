module top_module( devRevision );output  [31:0]   devRevision;

wire    [7:0]    relYear;
wire    [7:0]    relMonth;
wire    [7:0]    relDay;
wire    [7:0]    buildNum;
wire    [31:0]   devRevision;

assign relYear            = 8'h15;      
assign relMonth           = 8'h06;      
assign relDay             = 8'h29;      
assign buildNum           = 8'b0000001; 


assign devRevision = {relYear,relMonth,relDay, buildNum};

endmodule