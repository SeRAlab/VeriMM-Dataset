module top_module(
    input clk,
    input rst,
    input set,
    input d,
    output reg q,    // Changed 'output q' to 'output reg q'
    output qn
);always @(posedge clk) begin
    if (rst) begin
        q <= 0;
    end
    else if (set) begin
        q <= 1;
    end
    else begin
        q <= d;
    end
end

assign qn = ~q;

endmodule