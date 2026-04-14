module top_module(
    input logic [3:0] a,
    input logic [3:0] b,
    input logic rst,
    input logic clk,  // Added clk input
    output logic [3:0] out
);always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0;
        end else begin
            out <= (a + b) % 16;
        end
    end

endmodule