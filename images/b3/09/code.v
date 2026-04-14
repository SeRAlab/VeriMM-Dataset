module top_module(
    input SPI_clock,
    input clock,
    
    output SPI_clock_synced
);reg [1:0] temp;
    always @(posedge clock)
        temp = SPI_clock;
        
    assign SPI_clock_synced = temp;
endmodule