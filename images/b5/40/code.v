module top_module(
    input [2:0] ALUCtrl,
    input [31:0] inA,
    input [31:0] inB,
    output [31:0] out,
    output Zero
    );parameter ADD_op = 3'b000, SUB_op = 3'b001, SLT_op = 3'b010, SRL_op = 3'b011;
    parameter SLL_op = 3'b100, OR_op = 3'b101, AND_op = 3'b110, NOR_op = 3'b111;;
    
    reg [31:0] result;

    assign Zero = (result == 0);
    assign out = result;
    always @(inA or inB or ALUCtrl) begin
        case(ALUCtrl) 
			AND_op: result <= inA & inB;
			OR_op: result <= inA | inB;
			ADD_op: result <= inA + inB;
			SUB_op: result <= inA - inB;
			SLT_op: result <= inA < inB;
            SLL_op: result <= inB << inA;
			default: result <= 0;
        endcase
    end

endmodule