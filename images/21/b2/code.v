module divide_by_4 (
    input wire clk,
    input wire reset,
    input wire [1:0] in,
    output reg [1:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 2'b00;
        end else begin
            out <= in >> 2; // Divide by 4 is the same as right shift by 2
        end
    end
endmodule