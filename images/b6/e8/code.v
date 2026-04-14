module top_module(
    input wire D,
    input wire RESET,
    input wire GATE,
    output reg Q
);always @(posedge GATE) begin
    if (RESET) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule