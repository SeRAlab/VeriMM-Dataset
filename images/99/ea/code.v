module top_module(
    input clk,
    input [7:0] i0,
    input [7:0] i1,
    input alu_op,
    output reg [7:0] o
);always @(posedge clk) begin
        case(alu_op)
            1'b0: o = i0 + i1;
            1'b1: o = i0 << i1;
        endcase
    end

endmodule