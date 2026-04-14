module top_module(
    input RESET,
    input CLK,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    output reg [7:0] StatusLED
    );parameter [7:0] StatusLEDBaseAddr = 8'hC0;





    always@(posedge CLK) begin
        if((BUS_ADDR == StatusLEDBaseAddr) & BUS_WE) begin
            StatusLED [3:0] <= BUS_DATA [3:0];
            end
        if((BUS_ADDR == StatusLEDBaseAddr + 1'b1) & BUS_WE) begin
            StatusLED [4] <= BUS_DATA [0];
            end
        if((BUS_ADDR == (StatusLEDBaseAddr + 2'h2)) & BUS_WE) begin
            StatusLED [5] <= BUS_DATA [0];
            end
        if((BUS_ADDR == (StatusLEDBaseAddr + 2'h3)) & BUS_WE) begin
            StatusLED [6] <= BUS_DATA [0];
            end
        if((BUS_ADDR == (StatusLEDBaseAddr + 3'h4)) & BUS_WE) begin
            StatusLED [7] <= BUS_DATA [0];
            end
    end 

endmodule