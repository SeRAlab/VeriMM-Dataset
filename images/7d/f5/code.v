module top_module(
input i_SDI,
input i_RST,
input i_CLK,
output  [7:0] o_LED
    );reg [7:0] i;
reg [27:0] counter1;
wire Y1;
always @ (posedge(i_CLK))
begin
	counter1 <= counter1 + 1;
end

assign Y1 = counter1[22];

always@(posedge(Y1))
begin
i[0] = i_SDI; 
if(i_RST == 1)  
    i = i << 1'b1;
end
assign o_LED = i;
endmodule