module register(CLK, CLR, LOAD, DATA_IN, DATA_OUT);
input CLK, CLR, LOAD;
input [7:0] DATA_IN;
output [7:0] DATA_OUT;
reg [7:0] DATA_OUT;

always @(posedge CLK or posedge CLR) begin
    if (CLR)
        DATA_OUT <= 0;
    else if (LOAD)
        DATA_OUT <= DATA_IN;
end

endmodule