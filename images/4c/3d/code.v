module binary_counter (CLK, RESET, COUNT);
input CLK;
input RESET;
output reg [2:0] COUNT;

always @(posedge CLK) begin
    if (RESET)
        COUNT <= 3'b000;
    else
        COUNT <= COUNT + 1;
end

endmodule