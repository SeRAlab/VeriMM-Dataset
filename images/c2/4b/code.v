module binary_max (
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] max,
    output reg max_sel
);

always @(posedge clk) begin
    if (A > B) begin
        max <= A;
        max_sel <= 1;
    end else begin
        max <= B;
        max_sel <= 0;
    end
end

endmodule