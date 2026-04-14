module counter_4bit_sync_reset(CLK, RESET, Q);
input CLK, RESET;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (RESET)
        Q <= 4'b0000;
    else
        Q <= Q + 1;
end
endmodule