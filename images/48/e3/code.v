module top_module(
    input [2:0] in,
    input enable,
    output reg out
);always @ (in or enable) begin
    if (enable) begin
        casez (in)
            3'b000: out = in[0];
            3'b001: out = in[1];
            3'b010: out = in[2];
            3'b011: out = in[0];
            3'b100: out = in[1];
            3'b101: out = in[2];
            default: out = 1'b0;
        endcase
    end else begin
        out = 1'b0;
    end
end

endmodule