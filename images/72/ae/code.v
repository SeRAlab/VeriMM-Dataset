module top_module(
    input [3:0] a,
    input [3:0] b,
    input [1:0] mode,
    output reg [3:0] out
);always @(*) begin
        case (mode)
            2'b00: out = a << b[1:0]; // logical left shift
            2'b01: out = a >> b[1:0]; // logical right shift
            2'b10: out = $signed(a) >>> b[1:0]; // arithmetic right shift
            2'b11: out = {a[0], a[3:1]}; // rotate right by 1 position (binary rotation)
        endcase
    end

endmodule