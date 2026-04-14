module top_module(
		input wire hold,
		input wire [7:0]in_rtc_dato,
		input wire [7:0]in_count_dato,
		input wire clk, 
		input wire reset, 
		input wire chip_select, 
		output wire [7:0]out_dato_vga,
		output wire [7:0]out_dato_rtc
    );reg [7:0]reg_dato;
reg [7:0]next_dato;



always@(negedge clk, posedge reset)
begin
	if(reset) reg_dato <= 0;
	else reg_dato <= next_dato;
end


always@*
	begin
	if (~hold) begin
	case(chip_select)
	1'b0: next_dato = in_rtc_dato;
	1'b1: next_dato = in_count_dato;
	endcase
	end
	else next_dato = reg_dato;
	end



assign out_dato_vga = reg_dato;
assign out_dato_rtc = 8'h00;

endmodule