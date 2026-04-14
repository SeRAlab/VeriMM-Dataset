module top_module(
    input [2:0] D,
    input UD,
    input LD,
    input CLK,
    output reg [2:0] Q
);always @(posedge CLK) begin
    if (LD) begin
        Q <= D;
    end else begin
        if (UD) begin
            Q <= Q - 1;
        end else begin
            Q <= Q + 1;
        end
    end
end

endmodule