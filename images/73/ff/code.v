module top_module(input [7:0] data_in , output reg[9:0] data_out);always @(*)
begin
data_out = 10'd0;
case(data_in)
8'h00:data_out<=10'd1;
8'h01:data_out<=10'd2;
8'h02:data_out<=10'd4;
8'h42:data_out<=10'd8;
8'h04:data_out<=10'd16;
8'h44:data_out<=10'd32;
8'h05:data_out<=10'd64;
8'h45:data_out<=10'd128;
8'h0a:data_out<=10'd256;
8'h4a:data_out<=10'd512;
default: data_out<=10'd0;
endcase

end
endmodule