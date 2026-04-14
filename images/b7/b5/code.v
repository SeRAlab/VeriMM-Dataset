module counter_4bit(CLK, RESET, COUNT);
input CLK;
input RESET;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 4'b0000;
    end else begin
        COUNT <= COUNT + 1;
    end
end

endmodule