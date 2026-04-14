module top_module(
    input in0,
    input in1,
    input sel,
    output reg out
);always @ (sel, in0, in1) begin
    if (sel) begin
        out <= in1;
    end else begin
        out <= in0;
    end
end

endmodule