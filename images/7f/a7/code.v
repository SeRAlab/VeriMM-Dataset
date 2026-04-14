module top_module(
    input [3:0] A,
    input B,
    input RST,
    input clk,        // Added clk input
    output reg [4:0] Q
);always @(posedge clk) begin
    if (RST) begin
        Q <= 0;
    end else begin
        Q <= A + B;
    end
end

endmodule