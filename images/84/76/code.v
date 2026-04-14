module dff_async_reset_enable (D, CLK, RESET, EN, Q);
input D, CLK, RESET, EN;
output reg Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 1'b0;
    else if (EN)
        Q <= D;
end

endmodule