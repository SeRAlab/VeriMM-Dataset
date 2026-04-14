module top_module( input clk, 			output wire TXD, 
					input[7:0]dat, 	output wire ce_tact, 
					input st, 			output reg en_tx_byte=0, 
											output reg [3:0] cb_bit=0,
											output wire T_start, 
											output wire T_dat, 
											output wire T_stop, 
											output wire ce_stop, 
											output reg [7:0] sr_dat=0 );parameter Fclk=50000000 ; 
parameter VEL = 38400 ; 
parameter Nt = Fclk/VEL ; 
reg [11:0]cb_tact=0 ; 
assign ce_tact = (cb_tact==Nt) ; 
assign T_start = ((cb_bit==0) & en_tx_byte) ; 
assign T_dat = (cb_bit<9) & (cb_bit>0); 
assign T_stop = ((cb_bit==9) & en_tx_byte); 
assign ce_stop = T_stop & ce_tact ; 
assign TXD = T_start? 0 : T_dat? sr_dat[0] : 1 ; 
wire start = st & !en_tx_byte ;


always @ (posedge clk) begin
cb_tact <= (start | ce_tact)? 1 : cb_tact+1 ; 
en_tx_byte <= st? 1 : ce_stop? 0 : en_tx_byte ;
cb_bit <= start? 0 : (ce_tact & en_tx_byte)? cb_bit+1 : cb_bit ;
sr_dat <= (T_start & ce_tact)? dat : (T_dat & ce_tact)? sr_dat>>1 : sr_dat ; 
end
endmodule