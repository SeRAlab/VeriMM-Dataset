module top_module(
input [31:0] datain,
input [4:0] shftamt,
output reg[31:0] data_out,
input shift_len,
input shift_ren
);always @(*)
begin
data_out = 32'd0;
if(shift_ren)
data_out = datain >> shftamt;
if(shift_len)
data_out = datain << shftamt;
end

endmodule