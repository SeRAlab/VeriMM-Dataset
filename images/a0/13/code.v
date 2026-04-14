module top_module(input clk, input reset, input set, input d, output reg q, output reg qb);always @(posedge clk) begin
    if (reset) begin
        q <= 0;
        qb <= 1;
    end else if (set) begin
        q <= 1;
        qb <= 0;
    end else begin
        q <= d;
        qb <= ~d;
    end
end

endmodule