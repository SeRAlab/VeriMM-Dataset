module top_module(
    data1_i,
    data2_i,
    ALUCtrl_i,
    Zero_o,
    data_o
);input wire signed [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output Zero_o;
output [31:0] data_o;

reg signed [31:0] data_o;

`define AND 3'b000 
`define XOR 3'b001 
`define ADD 3'b010 
`define SUB 3'b110 
`define SLL 3'b111 
`define SRA 3'b101 
`define MUL 3'b011 

always @(data1_i or data2_i or ALUCtrl_i) begin
    case (ALUCtrl_i)
    `AND: data_o = data1_i & data2_i;
    `XOR: data_o = data1_i ^ data2_i;
    `ADD: data_o = data1_i + data2_i;
    `SUB: data_o = data1_i - data2_i;
    `SLL: data_o = data1_i << data2_i;
    `SRA: data_o = data1_i >>> {27'b0, data2_i[4:0]};
    `MUL: data_o = data1_i * data2_i;
endcase

end

endmodule