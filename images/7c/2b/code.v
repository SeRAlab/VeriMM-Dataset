module top_module(
    input wire in0,
    input wire in1,
    input wire sel,
    output reg out
);always @(*) begin
    if (sel == 0) begin
        out = in0;
    end else begin
        out = in1;
    end
end

endmodule