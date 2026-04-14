module top_module(
    input [3:0] in,
    output reg [3:0] out
);always @(*) begin
        if (in[0] == 1'b0) begin
            out = {1'b0, in[3:1]};
        end else begin
            out = {1'b1, in[3:1]};
        end
    end

endmodule