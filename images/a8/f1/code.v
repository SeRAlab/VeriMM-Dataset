module top_module(
    input wire clk,
    input wire [2:0] abc,
    output reg [7:0] y
);always @(posedge clk) begin
        y <= 8'b00000001 << abc;
    end

endmodule