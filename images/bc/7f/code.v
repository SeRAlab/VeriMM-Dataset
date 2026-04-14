module top_module(
    input [0:0] address,
    input clock,
    output reg [15:0] q
);always @(posedge clock) begin
    if (address == 1'b0) begin
        q <= 16'b0000000000000000;
    end else if (address == 1'b1) begin
        q <= 16'b1111111111111111;
    end
end

endmodule