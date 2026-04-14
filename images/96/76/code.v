module top_module(
    input clk, rst, load,
    input [7:0] D,
    output reg [7:0] Q
);always @(posedge clk) begin
    if (rst) begin
        Q <= 8'b0;
    end else if (load) begin
        Q <= D;
    end else begin
        Q <= Q + D;
    end
end

endmodule