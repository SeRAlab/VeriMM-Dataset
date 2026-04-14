module top_module(
    input CLOCK,
    output NEWCLOCK ,
    output clk,
    output clk298,
    output clkShine,
    output clk381
    );reg [25:0] COUNT = 1'b0;
    
    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1;
    end
    assign clk381=COUNT[17];
    assign clkShine = COUNT[23]; 
    assign clk298 = COUNT[25]; 
    assign NEWCLOCK = COUNT[3];
    assign clk = COUNT[4]; 
    
endmodule