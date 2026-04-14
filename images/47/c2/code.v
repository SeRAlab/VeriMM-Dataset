module top_module(alu_out, accum, data, opcode, zero, clk, reset);input[7:0] accum; input[7:0] data;
input[2:0] opcode; 
input clk, reset;
output zero;
output[7:0] alu_out;
reg[7:0] alu_out;
wire zero;

assign zero = !accum;


always@(posedge clk)
    begin
        if(reset == 1)
            alu_out = 0;
        else
            case(opcode)
            3'b000: alu_out = accum;
            3'b001: alu_out = accum + data;
            3'b010: alu_out = accum - data;
            3'b011: alu_out = accum & data;
            3'b100: alu_out = accum ^ data;
            3'b101: 
                if(accum[7] == 1)
                    alu_out = ~accum + 1;
                else
                    alu_out = accum;
            3'b110: alu_out = ~accum + 1;
            3'b111: alu_out = data;
            default:alu_out = 0;
        endcase
    end
endmodule