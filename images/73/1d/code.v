module top_module(
            opB, opA,
            op,
            result);input [31:0] opA;
input [31:0] opB;
input [1:0] op;
output [31:0] result;

reg [31:0] logic_result;

always@(opA or opB or op )
    case(op)
        2'b00:
            logic_result=opA&opB;
        2'b01:
            logic_result=opA|opB;
        2'b10:
            logic_result=opA^opB;
        2'b11:
            logic_result=~(opA|opB);
    endcase

assign result=logic_result;

endmodule