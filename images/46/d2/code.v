module top_module(
input clk, reset,
input [1:0] select,
input [BIT_WIDTH-1:0] in0, in1, in2, in3,
output reg [BIT_WIDTH-1:0] out
);parameter BIT_WIDTH = 32;

always @(*) begin
    case (select)
        0: out <= in0;
        1: out <= in1;
        2: out <= in2;
        3: out <= in3;
        default: out <= {BIT_WIDTH{1'bz}};
    endcase
end

endmodule