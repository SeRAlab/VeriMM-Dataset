module divide_by_4 (
    input wire [3:0] in,
    input wire clk,
    input wire reset,
    output reg [1:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 2'b00;
        end else begin
            out <= in[3:2]; // Divide by 4 by taking the two higher bits
        end
    end
endmodule