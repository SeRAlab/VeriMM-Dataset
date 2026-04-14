module top_module(
    // Inputs
    input clk,
    input reset,

    input [1:0] address,
    input chipselect,
    input read,
    input write,
    input [15:0] writedata,

    input OTG_INT0,
    input OTG_INT1,

    // Bidirectionals
    inout [15:0] OTG_DATA,

    // Outputs
    output reg [15:0] readdata,

    output irq,

    output reg OTG_RST_N,
    output reg [1:0] OTG_ADDR,
    output reg OTG_CS_N,
    output reg OTG_RD_N,
    output reg OTG_WR_N
);// Internal registers
reg [15:0] data_to_usb_chip;

// Default state
assign OTG_DATA = OTG_WR_N ? 16'hzzzz : data_to_usb_chip;
assign irq = ~OTG_INT1 | ~OTG_INT0;

always @(posedge clk) begin
    if (reset) begin
        readdata <= 16'h0000;
        OTG_RST_N <= 1'b0;
        OTG_ADDR <= 2'h0;
        OTG_CS_N <= 1'b1;
        OTG_RD_N <= 1'b1;
        OTG_WR_N <= 1'b1;
        data_to_usb_chip <= 16'h0000;
    end else begin
        readdata <= OTG_DATA;
        OTG_RST_N <= 1'b1;
        OTG_ADDR <= address;
        OTG_CS_N <= ~chipselect;
        OTG_RD_N <= ~read;
        OTG_WR_N <= ~write;
        data_to_usb_chip <= writedata[15:0];
    end
end

endmodule