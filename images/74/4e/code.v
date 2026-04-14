module top_module(clk, out, in, write, reset);output reg [3:0] out;
    input [3:0] in;
    input clk, write, reset;
    always @(negedge clk) begin
        if (reset == 0) begin
            out <= 4'b0;
        end
        else if (write == 0) begin
            out <= in;
        end
    end
endmodule