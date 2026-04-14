module top_module(
    input wire [3:0] MuxCtrl,
    input wire [31:0] exec_operand,
    input wire [31:0] load_data,
    input wire [31:0] exec_operand_fast,
    output reg [33:0] MuxData
    );always @(*)
begin
    case (MuxCtrl)
        4'b0101, 4'b0111 : MuxData = {2'b01,load_data};
        4'b0110, 4'b1000 : MuxData = {2'b10,load_data};
        4'b0011 : MuxData = {2'b01,exec_operand};
        4'b0100 : MuxData = {2'b10,exec_operand};
        4'b0001 : MuxData = {2'b01,exec_operand_fast};
        4'b0010 : MuxData = {2'b10,exec_operand_fast};
        default : MuxData = 0;
    endcase
end    
endmodule