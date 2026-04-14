module dff_async_reset (D, CLK, RESET, Q);
input D;
input CLK;
input RESET;
output reg Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 1'b0;
    end
    else begin
        Q <= D;
    end
end

endmodule