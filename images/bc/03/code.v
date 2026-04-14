module sync_counter (CLK, EN, COUNT);
input CLK, EN;
output reg [3:0] COUNT;

always @(posedge CLK) begin
    if (EN)
        COUNT <= COUNT + 1;
end

endmodule