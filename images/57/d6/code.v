module up_counter(CLK, LOAD, INIT_VAL, COUNT);
input CLK, LOAD;
input [3:0] INIT_VAL;
output reg [3:0] COUNT;

always @(posedge CLK) begin
    if (LOAD)
        COUNT <= INIT_VAL;
    else
        COUNT <= COUNT + 1;
end

endmodule