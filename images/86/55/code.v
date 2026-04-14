module top_module(
    input CLK,
    input [3:0] D,
    input RST,
    output reg [3:0] Q
);always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        Q <= D;
    end
end

endmodule