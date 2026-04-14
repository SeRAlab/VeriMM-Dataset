module top_module(
    input [1:0] ALUop,
    input [5:0] instru,
    input clk,
    output reg [2:0] contALU
    );always @(*) begin
        case (ALUop)
            2'b00: contALU = 3'b010; // AND
            2'b01: contALU = 3'b110; // OR
            default: begin
                case (instru)
                    6'b100000: contALU = 3'b010; // AND
                    6'b100010: contALU = 3'b110; // OR
                    6'b100100: contALU = 3'b000; // ADD
                    6'b100101: contALU = 3'b001; // SUB
                    6'b101010: contALU = 3'b111; // SLT
                    default: contALU = 3'b101; // NOR
                endcase
            end
        endcase
    end
    
endmodule