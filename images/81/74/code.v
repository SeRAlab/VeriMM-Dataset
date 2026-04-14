module top_module(
    vjtag_byteenable,
    vjtag_writedata,
    vjtag_address,
    sdram_readdatavalid,
    sdram_waitrequest,
    sdram_readdata,
    vjtag_write,
    vjtag_read,
    rst,
    clk,
    leds,
    vjtag_readdata,
    vjtag_waitrequest,
    vjtag_readdatavalid,
    sdram_address,
    sdram_read,
    sdram_write,
    sdram_writedata,
    sdram_byteenable
);input [3:0] vjtag_byteenable;
    input [31:0] vjtag_writedata;
    input [31:0] vjtag_address;
    input sdram_readdatavalid;
    input sdram_waitrequest;
    input [31:0] sdram_readdata;
    input vjtag_write;
    input vjtag_read;
    input rst;
    input clk;
    output [7:0] leds;
    output [31:0] vjtag_readdata;
    output vjtag_waitrequest;
    output vjtag_readdatavalid;
    output [31:0] sdram_address;
    output sdram_read;
    output sdram_write;
    output [31:0] sdram_writedata;
    output [3:0] sdram_byteenable;

    
    wire _48;
    wire [7:0] _50 = 8'b00000000;
    wire vdd = 1'b1;
    wire [7:0] _51 = 8'b00000000;
    wire _47;
    wire [7:0] _53 = 8'b00000001;
    wire [7:0] _54;
    wire [7:0] _49;
    reg [7:0] _52;

    
    assign _48 = vjtag_read | vjtag_write;
    assign _47 = ~ rst;
    assign _54 = _52 + _53;
    assign _49 = _54;
    always @(posedge clk or posedge _47) begin
        if (_47)
            _52 <= _51;
        else
            if (_48)
                _52 <= _49;
    end

    

    
    assign leds = _52;
    assign vjtag_readdata = sdram_readdata;
    assign vjtag_waitrequest = sdram_waitrequest;
    assign vjtag_readdatavalid = sdram_readdatavalid;
    assign sdram_address = vjtag_address;
    assign sdram_read = vjtag_read;
    assign sdram_write = vjtag_write;
    assign sdram_writedata = vjtag_writedata;
    assign sdram_byteenable = vjtag_byteenable;

endmodule