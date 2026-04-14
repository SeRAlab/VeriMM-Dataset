module binary_left_shifter (
    input [3:0] a,
    output reg [3:0] out);always @(*) begin
        out = a << 1;
    end

endmodule