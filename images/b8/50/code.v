module top_module(
    input [3:0] in,
    output [3:0] out
);assign out = ~in;

initial begin
    $display("Input: %b", in);
    $display("Output: %b", out);
end

endmodule