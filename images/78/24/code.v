module top_module(IMM, signExtend);input[15:0] IMM;
output[31:0] signExtend;

wire [15:0] IMM;
wire [31:0] signExtend;

assign signExtend[15:0] = IMM[15:0];
assign signExtend[31:16] = {16{IMM[15]}};

endmodule