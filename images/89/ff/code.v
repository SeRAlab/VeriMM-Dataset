module top_module(
    input D,
    input CLK,
    input SET,
    input NOTIFIER,
    output reg Q
);always @(posedge CLK or negedge SET) begin
    if (!SET) begin
        Q <= 1;
    end else if (NOTIFIER) begin
        Q <= D;
    end
end

endmodule