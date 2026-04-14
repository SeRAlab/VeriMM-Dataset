module top_module(
    input wire in0,
    input wire in1,
    output reg out
);always @(in0, in1) begin
    out = in0 & in1;
end

endmodule