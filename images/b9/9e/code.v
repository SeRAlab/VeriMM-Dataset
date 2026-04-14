module top_module(
    input clk,
    input [12:0] addr_in,
    output reg [9:0] bank0_addr,
    output reg [9:0] bank1_addr,
    output reg [9:0] bank2_addr,
    output reg [9:0] bank3_addr,
    output reg [1:0] sel,
    output reg odd
);reg [9:0] bank0_addr_dly;
reg [9:0] bank1_addr_dly;
reg [9:0] bank2_addr_dly;
reg [9:0] bank3_addr_dly;
reg [1:0] sel_dly;
reg odd_dly;

wire [9:0] addr = addr_in[12:3];
wire [9:0] addr_pone = addr_in[12:3] + 1;

// Delay sel and odd by 2 clock cycles
always @(posedge clk) begin
    sel_dly <= sel;
    odd_dly <= odd;
end

always @(posedge clk) begin
    sel <= sel_dly;
    odd <= odd_dly;
end

// Decode the address
always @(posedge clk) begin
    case (addr_in[2:1])
        2'b00: begin
            bank0_addr_dly <= addr;
            bank1_addr_dly <= addr;
            bank2_addr_dly <= addr;
            bank3_addr_dly <= addr;
        end
        2'b01: begin
            bank0_addr_dly <= addr_pone;
            bank1_addr_dly <= addr;
            bank2_addr_dly <= addr;
            bank3_addr_dly <= addr;
        end
        2'b10: begin
            bank0_addr_dly <= addr_pone;
            bank1_addr_dly <= addr_pone;
            bank2_addr_dly <= addr;
            bank3_addr_dly <= addr;
        end
        2'b11: begin
            bank0_addr_dly <= addr_pone;
            bank1_addr_dly <= addr_pone;
            bank2_addr_dly <= addr_pone;
            bank3_addr_dly <= addr;
        end
    endcase
end

// Output the delayed bank addresses
always @(posedge clk) begin
    bank0_addr <= bank0_addr_dly;
    bank1_addr <= bank1_addr_dly;
    bank2_addr <= bank2_addr_dly;
    bank3_addr <= bank3_addr_dly;
end

endmodule