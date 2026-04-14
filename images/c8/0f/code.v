module add_five(
    input [3:0] in,
    output [3:0] out,
    input clk
);

    assign out = in + 4'b0101;

    always @(posedge clk) begin
        out <= in + 4'b0101;
    end

endmodule