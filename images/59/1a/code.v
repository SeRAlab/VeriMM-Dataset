module top_module(
    input s_axi_aclk,
    input [31:0] s_axi_wdata,
    input [11:0] addra,
    input web,
    output reg done,
    output reg busy
);parameter RAM_DEPTH = 1024;
    parameter RAM_WIDTH = 32;

    reg [RAM_WIDTH-1:0] ram [0:RAM_DEPTH-1];
    reg [11:0] write_addr;
    reg [31:0] write_data;
    reg write_enable;

    always @(posedge s_axi_aclk) begin
        if (web) begin
            write_addr <= addra;
            write_data <= s_axi_wdata;
            write_enable <= 1;
            busy <= 1;
        end
    end

    always @(posedge s_axi_aclk) begin
        if (write_enable) begin
            ram[write_addr] <= write_data;
            write_enable <= 0;
            done <= 1;
            busy <= 0;
        end
    end

endmodule