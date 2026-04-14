module top_module(
    input clk,
    input reset,
    input write_enable,
    input [15:0] address,
    input [15:0] data_in,
    output reg [15:0] data_out,
    output reg sram_ce_n,
    output reg sram_oe_n,
    output reg sram_we_n,
    output reg [15:0] sram_addr,
    inout [15:0] sram_dq
);reg [15:0] sram_data;

// Write enable signal
assign sram_we_n = write_enable ? 1'b0 : 1'b1;

// Address signal
assign sram_addr = address;

// Data signal
assign sram_dq = write_enable ? data_in : 16'bZ;

// Chip enable and output enable signals
always @ (posedge clk) begin
    if (reset) begin
        sram_ce_n <= 1'b1;
        sram_oe_n <= 1'b1;
    end else begin
        sram_ce_n <= 1'b0;
        sram_oe_n <= 1'b0;
    end
end

// Read data from SRAM
always @ (posedge clk) begin
    if (reset) begin
        data_out <= 16'b0;
    end else begin
        if (!write_enable) begin
            data_out <= sram_data;
        end
    end
end

// Write data to SRAM
always @ (posedge clk) begin
    if (reset) begin
        sram_data <= 16'b0;
    end else begin
        if (write_enable) begin
            sram_data <= data_in;
        end
    end
end

endmodule