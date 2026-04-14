module top_module(
	stall_select_i   ,
    flush_select_i   ,
    EX_signal_i    ,
    MEM_signal_i   ,
    WB_signal_i    ,
    EX_signal_o    ,
    MEM_signal_o   ,
    WB_signal_o   
);input stall_select_i, flush_select_i;
input [1:0] EX_signal_i;
input [2:0] MEM_signal_i;
input [1:0] WB_signal_i;

output reg [1:0] 	EX_signal_o;
output reg [2:0] 	MEM_signal_o;
output reg [1:0] 	WB_signal_o;

always@(stall_select_i or EX_signal_i or MEM_signal_i or WB_signal_i or flush_select_i)begin
	if (stall_select_i || flush_select_i )begin
		EX_signal_o <= 2'bxx;
		MEM_signal_o <= 3'bxxx;
		WB_signal_o <= 2'bxx;
	end
	else	begin
		EX_signal_o <= EX_signal_i;
		MEM_signal_o <= MEM_signal_i;
		WB_signal_o <= WB_signal_i;
	end

end
endmodule