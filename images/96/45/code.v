module binary_counter_6bit(CLK, RESET, ENABLE, COUNT);
input CLK;
input RESET;
input ENABLE;
output reg [5:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 6'b000000;
    end else if (ENABLE) begin
        COUNT <= COUNT + 1;
    end
end

endmodule