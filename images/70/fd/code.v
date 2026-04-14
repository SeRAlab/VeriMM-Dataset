module top_module(
	input[9:0]             lut_index, 
	output reg[31:0]       lut_data   
);always@(*)
begin
	case(lut_index)
		10'd0: lut_data <= {8'h72,16'h08,8'h35};
		10'd1: lut_data <= {8'h7a,16'h2f,8'h00};
		10'd2: lut_data <= {8'h60,16'h05,8'h10};
		10'd3: lut_data <= {8'h60,16'h08,8'h05};
		10'd4: lut_data <= {8'h60,16'h09,8'h01};
		10'd5: lut_data <= {8'h60,16'h05,8'h04}; 
		default:lut_data <= {8'hff,16'hffff,8'hff};
	endcase
end


endmodule