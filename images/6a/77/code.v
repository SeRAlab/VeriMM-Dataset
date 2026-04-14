module top_module(
    input [7:0] a,
    input [7:0] b,
    input reset_n,
    output reg [7:0] out
);always @ (posedge reset_n) begin
    if (reset_n == 0) begin
        out <= 8'b0;
    end else begin
        out <= a & b;
    end
end

endmodule