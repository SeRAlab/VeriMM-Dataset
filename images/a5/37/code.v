module top_module(
    input [31:0] in,
    input clk,
    input reset,
    output reg [31:0] out
);reg [7:0] shift_reg [3:0];
reg [1:0] stage;

always @(*) begin
    case(stage)
        0: begin
            shift_reg[0] = in[7:0];
            shift_reg[1] = in[15:8];
            shift_reg[2] = in[23:16];
            shift_reg[3] = in[31:24];
        end
        1: begin
            shift_reg[0] = shift_reg[2];
            shift_reg[1] = shift_reg[3];
            shift_reg[2] = shift_reg[0];
            shift_reg[3] = shift_reg[1];
        end
        default: begin
            shift_reg[0] = 0;
            shift_reg[1] = 0;
            shift_reg[2] = 0;
            shift_reg[3] = 0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        stage <= 0;
    end else begin
        case(stage)
            0: stage <= 1;
            1: stage <= 2;
            default: stage <= 0;
        endcase
    end
end

always @(*) begin
    out = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
end

endmodule