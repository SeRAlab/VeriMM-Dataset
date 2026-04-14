module top_module(
		input wire aumentar, 
		input wire disminuir, 
		input wire clk, 
		input wire reset, 
		input wire chip_select, 
		output wire out_aumentar, 
		output wire out_disminuir 
    );reg aumentar_actual,disminuir_actual,aumentar_next,disminuir_next;


always@(posedge clk, posedge reset)
begin
	if(reset)
		begin
		aumentar_actual <= 0;
		disminuir_actual <= 0;
		end
	else
	begin
		aumentar_actual <= aumentar_next;
		disminuir_actual <= disminuir_next;
	end
end


always@*
	begin
	
	case(chip_select)
	
	1'b0: 
	begin
	aumentar_next = aumentar_actual;
	disminuir_next = disminuir_actual;
	end
	1'b1: 
	begin
	aumentar_next = aumentar;
	disminuir_next = disminuir;
	end
	endcase
	
	end

assign out_aumentar = aumentar_actual;
assign out_disminuir = disminuir_actual;

endmodule