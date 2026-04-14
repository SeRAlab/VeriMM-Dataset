module top_module(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);output [31:0] BusA, BusB;
    input [31:0] BusW;
    input [4:0] RA, RB, RW;
    input RegWr, Clk;

    reg [31:0] register;

    always @(posedge Clk)
        register[31] <= 0;
    
    assign #2 BusA = register[RA];
    assign #2 BusB = register[RB];

    always @(negedge Clk)
        if(RegWr && RW != 31)
        register[RW] <= #3 BusW;
endmodule