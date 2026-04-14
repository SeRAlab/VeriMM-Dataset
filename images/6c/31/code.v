module top_module(
input BTN_UP, output reg [7:0] DAT=8'h80, 
input BTN_DOWN,
input clk,
input ce);reg [1:0]Q_UP ; 
reg [1:0]Q_DOWN ; 
wire st_UP= Q_UP[0] & !Q_UP[1] & ce ; 
wire st_DOWN= Q_DOWN[0] & !Q_DOWN[1] & ce ; 
wire Mmax=(DAT==8'hFF); 
wire Mmin=(DAT==8'h01); 
always @ (posedge clk) if (ce) begin
Q_UP <= Q_UP<<1 | BTN_UP ; 
Q_DOWN <= Q_DOWN<<1 | BTN_DOWN ; 
DAT <= (!Mmax & st_UP)? DAT+1 : (!Mmin & st_DOWN)? DAT-1 : DAT ;
end
endmodule