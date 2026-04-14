module counter_with_set(CLK, SET, EN, COUNT);
input CLK, SET, EN;
output reg [3:0] COUNT;

always @(posedge CLK or posedge SET) begin
    if (SET)
        COUNT <= 4'b1000;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule