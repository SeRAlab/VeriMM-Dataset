module divide_by_4 (
    input clk,
    input reset,
    input [7:0] in,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0;
        end else begin
            out <= in >> 2; // Perform divide by 4 by right shifting by 2
        end
    end
endmodule