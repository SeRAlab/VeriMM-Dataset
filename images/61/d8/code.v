module top_module(
    input clk,
    input reset,
    input d,
    output reg q  // Changed to output reg to fix redeclaration issue
);always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule