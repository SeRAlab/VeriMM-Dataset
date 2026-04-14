module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [1:0] count,
    output reg carry
);always @(posedge clk)
        if (sreset) begin
            count <= 2'b0;
            carry <= 0;
        end else if (enable) begin
            if (count == 2'b11) begin
                count <= 2'b0;
                carry <= 1;
            end else begin
                count <= count + 1;
                carry <= 0;
            end
        end
endmodule