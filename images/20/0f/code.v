module divide_by_4 (
    input [3:0] in,
    output reg [1:0] out,
    input clk,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 2'b00;
        end else begin
            out <= in >> 2; // Divide by 4 is equivalent to right shifting by 2 bits
        end
    end
endmodule