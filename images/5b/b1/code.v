module top_module(
    input clk,
    input reset,
    input set,
    input d,
    output reg q,    // Change output to reg type
    output qn
);// Removed the internal reg declaration for q, since it's now declared at the output

always @(posedge clk or negedge reset or negedge set) begin
    if (!reset) begin
        q <= 1'b0;
    end else if (!set) begin
        q <= 1'b1;
    end else begin
        q <= d;
    end
end

assign qn = ~q;

endmodule