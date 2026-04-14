module top_module(
    data_i,
	 ori_i,
    data_o
    );input   [16-1:0] data_i;
input				  ori_i;
output  [32-1:0] data_o;


reg     [32-1:0] data_o;


always@(*)begin
	if(ori_i==1'b1)begin
		data_o [31:16] = 16'b0000000000000000;
		data_o [15:0] = data_i;
	end
	else begin
		data_o [31:16] = {data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15], data_i[15]};
		data_o [15:0] = data_i;
	end
end
endmodule