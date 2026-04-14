module top_module(clk, Reset, PCWre, nextAddress, Address);input clk, Reset, PCWre;
    input [31:0] nextAddress;
    output reg [31:0] Address;
    always @(posedge clk)begin
        if (Reset == 0)
            Address = 0;
        else if(PCWre==1)
            Address = nextAddress;
    end
endmodule