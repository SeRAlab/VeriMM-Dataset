module top_module(
    input a,
    input b,
    input clk,          // Added clk input
    output reg y
);reg [1:0] pipeline;

    always @ (posedge clk) begin
        pipeline[0] <= a & b;
        pipeline[1] <= pipeline[0];
        y <= pipeline[1];
    end

endmodule