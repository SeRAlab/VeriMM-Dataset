module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output reg [3:0] result
);reg [3:0] sum;
reg [3:0] diff;

always @(*) begin
    sum = a + b;
    diff = a - b;
end

always @(posedge mode) begin
    if (mode) begin
        result <= diff;
    end else begin
        result <= sum;
    end
end

endmodule