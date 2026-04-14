module top_module(input clk, input signed [15:0] a, input signed [15:0] b, output signed [31:0] out);reg signed [31:0] acc;
    always @(posedge clk) begin
        acc <= a * b;
    end
    assign out = acc;
endmodule