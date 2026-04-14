module top_module(DOut1, AddrA, WEA, DataInA, clock);output [7:0] DOut1;
    input [2:0] AddrA;
    input WEA;
    input [7:0] DataInA;
    input clock;
    reg [7:0] SRAM [7:0];
    reg [7:0] DOut1;
    wire [2:0] AddrA;
    wire [7:0] DataInA;
    
    always @ (posedge clock)
    begin
        if (WEA==1)
            SRAM[AddrA] <= DataInA;
        else if (WEA==0)
            DOut1 <= SRAM[AddrA];
    end
endmodule