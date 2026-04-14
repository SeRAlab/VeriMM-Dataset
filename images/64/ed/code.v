module top_module(xor_to_InvRows, InvRows_to_InvSBox);input[127:0] xor_to_InvRows;
output[127:0] InvRows_to_InvSBox;


assign InvRows_to_InvSBox[127:96] = {xor_to_InvRows[31:24], xor_to_InvRows[55:48], xor_to_InvRows[79:72], xor_to_InvRows[103:96]};
assign InvRows_to_InvSBox[95:64] = {xor_to_InvRows[127:120], xor_to_InvRows[23:16], xor_to_InvRows[47:40], xor_to_InvRows[71:64]};
assign InvRows_to_InvSBox[63:32] = {xor_to_InvRows[95:88], xor_to_InvRows[119:112], xor_to_InvRows[15:8], xor_to_InvRows[39:32]};
assign InvRows_to_InvSBox[31:0] = {xor_to_InvRows[63:56], xor_to_InvRows[87:80], xor_to_InvRows[111:104], xor_to_InvRows[7:0]};

endmodule