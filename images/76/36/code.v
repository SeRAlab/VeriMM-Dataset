module binary_counter(CLK, RST, EN, LOAD, LOAD_VAL, COUNT);
input CLK, RST, EN, LOAD;
input [2:0] LOAD_VAL;
output [2:0] COUNT;
reg [2:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 3'b000;
    else if (LOAD)
        COUNT <= LOAD_VAL;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule