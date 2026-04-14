module divide_by_8(
    input wire clk,
    input wire reset,
    input wire [2:0] in,
    output reg out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            out <= in[2];  // The result of dividing by 8 is simply the MSB of the 3-bit input
        end
    end
endmodule