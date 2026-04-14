module top_module(
    input D,
    input CLK,
    input RESET,
    output reg Q
);always @(posedge CLK, posedge RESET) begin
    if (RESET == 1'b1) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

endmodule