module top_module(
    input CLK, UP, DOWN, LD,
    input [2:0] DIN,
    output reg [2:0] Q
);always @(posedge CLK) begin
    if (LD) begin
        Q <= DIN;
    end else if (UP) begin
        Q <= Q + 1;
    end else if (DOWN) begin
        Q <= Q - 1;
    end
end

endmodule