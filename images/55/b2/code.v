module counter_2bit (CLK, RESET, COUNT);
input CLK, RESET;
output reg [1:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 2'b00;
    end
    else begin
        COUNT <= COUNT + 1;
    end
end

endmodule