module top_module(
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);reg [3:0] q1, q2, q3, q4;

always @(posedge clk) begin
    if (reset) begin
        q1 <= 4'b0000;
        q2 <= 4'b0000;
        q3 <= 4'b0000;
        q4 <= 4'b0000;
    end else if (slowena) begin
        q1 <= q4;
        q2 <= q1;
        q3 <= q2;
        q4 <= q3 + 1;
    end
end

assign q = slowena ? q1 : q4;

endmodule