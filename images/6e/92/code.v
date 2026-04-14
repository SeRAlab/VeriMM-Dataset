module top_module(
    input wire D,
    input wire EN,
    input wire CLK,
    output reg Q
);always @(posedge CLK)
begin
    if (EN)
        Q <= D;
end

endmodule