module top_module(
    input clk,
    input d,
    input set,
    input clr,
    output reg q
);always @(posedge clk) begin
    if (set) begin
        q <= 1;
    end else if (clr) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule