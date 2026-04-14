module top_module
(
    input clk,
    input sreset,
    input enable,
    output reg [5:0] count,
    output reg carry_out
);always @(posedge clk)
        if (sreset) begin
            count <= 6'b0;
            carry_out <= 0;
        end else if (enable) begin
            if (count == 6'b111111) begin
                count <= 6'b0;
                carry_out <= 1;
            end else begin
                count <= count + 1;
                carry_out <= 0;
            end
        end
endmodule