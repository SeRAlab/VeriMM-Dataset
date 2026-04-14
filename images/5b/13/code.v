module counter_3bit_updown(CLK, RESET, UP, COUNT);
input CLK;
input RESET;
input UP;
output reg [2:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 3'b000;
    end else if (UP) begin
        COUNT <= COUNT + 1;
    end else begin
        COUNT <= COUNT - 1;
    end
end

endmodule