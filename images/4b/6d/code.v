module top_module(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);reg [7:0] q1, q2, q3, q4, q5, q6, q7, q8;

always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
        q1 <= 8'h5A;
        q2 <= 8'h5A;
        q3 <= 8'h5A;
        q4 <= 8'h5A;
        q5 <= 8'h5A;
        q6 <= 8'h5A;
        q7 <= 8'h5A;
        q8 <= 8'h5A;
    end else begin
        q1 <= d;
        q2 <= q1;
        q3 <= q2;
        q4 <= q3;
        q5 <= q4;
        q6 <= q5;
        q7 <= q6;
        q8 <= q7;
    end
end

assign q = q8;

endmodule