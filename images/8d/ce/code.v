module top_module(
    input [3:0] a,
    input [3:0] b,
    input control,
    output reg [3:0] out
);reg [3:0] sum1, sum2, diff1, diff2;

always @ (posedge control) begin
    sum1 <= a + b;
    diff1 <= a - b;
end

always @ (posedge control) begin
    sum2 <= sum1;
    diff2 <= diff1;
end

always @ (posedge control) begin
    if (control) begin
        out <= sum2;
    end else begin
        out <= diff2;
    end
end

endmodule