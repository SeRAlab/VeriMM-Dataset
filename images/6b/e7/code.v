module ram_8bit_16word(CLK, WE, RE, ADDR, DATA_IN, DATA_OUT);
input CLK, WE, RE;
input [3:0] ADDR;
input [7:0] DATA_IN;
output [7:0] DATA_OUT;
reg [7:0] DATA_OUT;
reg [7:0] mem [0:15];

always@(posedge CLK) begin
    if (WE)
        mem[ADDR] <= DATA_IN;
    if (RE)
        DATA_OUT <= mem[ADDR];
end

endmodule