module top_module(
    input [3:0] in,
    output reg [1:0] out
);always @(*) begin
        if (in < 4) begin
            out = in / 2;
        end else begin
            out = in - 2;
        end
    end

endmodule