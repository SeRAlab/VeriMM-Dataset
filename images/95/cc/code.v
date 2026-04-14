module top_module(clk, rst_n, in1, in2, out);input clk;
input rst_n;
input [7:0] in1;
input [7:0] in2;

output reg [8:0] out;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out <= 0;
    end
    else begin
        out <= {1'b0, in1} + {1'b0, in2};
    end
end

endmodule