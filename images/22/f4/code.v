module power_gating(input enable, input [3:0] data, output [3:0] gated_data);  
assign gated_data = enable ? data : 4'b0000;  
endmodule