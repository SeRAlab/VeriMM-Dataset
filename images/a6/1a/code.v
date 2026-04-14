module top_module(intrinsic_info, 
				msg_from_check0, 
				msg_from_check1, 
				msg_from_check2, 
				data_out
				);input 			[7:0] intrinsic_info;
input 			[7:0] msg_from_check0;
input 			[7:0] msg_from_check1;
input 			[7:0] msg_from_check2;
output reg 			  data_out;
reg 			[7:0] vnu_data_out;



always @(msg_from_check0 or msg_from_check1 or msg_from_check2)
begin 
	vnu_data_out = intrinsic_info + msg_from_check0 + msg_from_check1 + msg_from_check2; 
	if(vnu_data_out[7] == 1 || vnu_data_out == 8'b0) begin 
		data_out <= 0;
	end
	else begin 
		data_out <= 1;
	end
end

endmodule