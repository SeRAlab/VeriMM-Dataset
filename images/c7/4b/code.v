module halves_sum(
    input [31:0] in,
    output reg [15:0] out
);

    always @(*) begin
        out = (in[31:16] + in[15:0]);
    end

endmodule