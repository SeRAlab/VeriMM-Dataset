module binary_counter_4bit (CLK, RESET, ENABLE, COUNT);
input CLK;
input RESET;
input ENABLE;
output reg [3:0] COUNT;

always @(posedge CLK) begin
    if (RESET) begin
        COUNT <= 4'b0000;
    end
    else if (ENABLE) begin
        COUNT <= COUNT + 1;
    end
end

endmodule