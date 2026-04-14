module up_counter(CLK, EN, RST, COUNT);
input CLK, EN, RST;
output reg [3:0] COUNT;

always@(posedge CLK or posedge RST) begin
    if(RST)
        COUNT <= 4'b0000;
    else if(EN)
        COUNT <= COUNT + 1;
end

endmodule