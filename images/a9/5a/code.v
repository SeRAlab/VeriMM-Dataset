module counter_3bit_sync_reset (CLK, RESET, Q);
input CLK;
input RESET;
output reg [2:0] Q;

always @(posedge CLK) begin
    if (RESET) begin
        Q <= 3'b000;
    end
    else begin
        Q <= Q + 1;
    end
end

endmodule