module top_module(
            opA, opB,
            op,
            result);parameter WIDTH=32;


input [WIDTH-1:0] opA;
input [WIDTH-1:0] opB;
input [2-1:0] op;
output [WIDTH-1:0] result;

reg [WIDTH-1:0] logic_result;

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