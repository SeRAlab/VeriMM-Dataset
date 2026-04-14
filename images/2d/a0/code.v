module divide_by_8 (
    input [2:0] in,
    output reg [2:0] out,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 3'b000; // Reset output
        end else begin
            out <= 3'b000; // Output is always 0 when dividing by 8
        end
    end
endmodule