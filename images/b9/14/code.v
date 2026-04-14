module binary_decoder (
    input [1:0] a,
    output reg [3:0] y);
always @(*) begin
    y = 4'b0000;
    y[a] = 1'b1;
end
endmodule