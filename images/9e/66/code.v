module top_module(
    input D,
    input CLK,
    input RESET,
    input SET,
    output reg Q
);always @(posedge CLK or negedge RESET or negedge SET) begin
    if (!RESET) begin
        Q <= 0;
    end else if (!SET) begin
        Q <= 1;
    end else begin
        Q <= D;
    end
end

endmodule