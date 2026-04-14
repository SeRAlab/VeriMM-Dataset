module top_module(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [1:0] csrALU_ctrl,
    output reg [31:0] ALU_out
    );always @ (*)
    begin
    case(csrALU_ctrl)
        2'b01:ALU_out = op2;
        2'b10:ALU_out = op1 | op2;
        2'b11:ALU_out = op1 & (~ op2);
        default:
        ALU_out = 32'h0;
    endcase
    end
endmodule