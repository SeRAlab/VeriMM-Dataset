module top_module(
    input [14:0] address,
    input clock,
    output reg [11:0] q
);always @(posedge clock) begin
        if (address >= 4096) begin
            q <= 12'b0;
        end else begin
            q <= $random;
        end
    end

endmodule