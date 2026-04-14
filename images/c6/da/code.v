module dff_async_reset (
    input D,
    input RESET,
    input CLK,
    output Q
);

reg Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

assign Q = Q;

endmodule