module d_latch (
    input wire D,
    input wire CLK,
    input wire RESET,
    output reg Q
);

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule