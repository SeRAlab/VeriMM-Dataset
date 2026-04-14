module DFF_async_reset (D, CLK, RST, Q);
input D, CLK, RST;
output reg Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

endmodule