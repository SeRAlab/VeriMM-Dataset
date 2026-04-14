module left_shifter(
    input clk,
    input reset,
    input [15:0] in,
    output reg [15:0] out);

    always @(posedge clk) begin
        if (reset)
            out <= 16'b0;
        else
            out <= in << 1;
    end
endmodule