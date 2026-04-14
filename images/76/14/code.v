module top_module(
        input  wire [1:0] c,
        input  wire [3:0] in0,
        input  wire [3:0] in1,
        output reg  [3:0] alu_out
    );always @ (in0, in1, c) begin
        case(c)
            2'b00: alu_out = in0 + in1;
            2'b01: alu_out = in0 - in1;
            2'b10: alu_out = in0 & in1;
            2'b11: alu_out = in0 ^ in1;
        endcase
    end

endmodule