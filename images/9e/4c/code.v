module counter_3bit_sync_reset(CLK, RESET, COUNT);
input CLK, RESET;
output [2:0] COUNT;
reg [2:0] COUNT;

always@(posedge CLK) begin
    if (RESET)
        COUNT <= 3'b000;
    else
        COUNT <= COUNT + 1;
end

endmodule