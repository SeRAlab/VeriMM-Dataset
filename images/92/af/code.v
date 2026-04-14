module top_module(
    rf_clock,

    rf_reset,

    rf_rd_addr_0,
    rf_rd_data_0,

    rf_wr_enable,
    rf_wr_addr,
    rf_wr_data
);input rf_clock;

    
    input rf_reset;
    input [4:0]rf_rd_addr_0;
    input rf_wr_enable;
    input [4:0]rf_wr_addr;
    input [31:0]rf_wr_data;

    
    output [31:0]rf_rd_data_0;

    reg [31:0]rf[31:0];

    reg [31:0]rf_rd_data_0;

    always @(posedge rf_clock)
    begin
        if (rf_wr_enable)
        begin
            rf[rf_wr_addr] <= rf_wr_data;
        end
    end

    always @(rf_rd_addr_0)
    begin
        rf_rd_data_0 = rf[rf_rd_addr_0];
    end
    
endmodule