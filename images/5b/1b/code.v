module top_module(CLK, D, reset, Q);input CLK, D, reset;
output Q;
reg Q;

always @(posedge CLK or posedge reset) begin
    if (reset) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule