module lfsr#(
    parameter WIDTH = 8,
    parameter POLY = 8'b10000011
)(
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] out
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        out <= 0;
    end else begin
        out <= {out[WIDTH-2:0], ^(out & POLY)};
    end
end

endmodule