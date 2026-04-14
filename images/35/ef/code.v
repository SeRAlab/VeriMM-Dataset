module divide_by_4 (
    input clk,
    input reset,
    input [1:0] in,
    output reg [1:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 2'b00;
    end else begin
        out <= in / 4; // Dividing by 4, results in 00 for all inputs in [0, 3]
    end
end

endmodule