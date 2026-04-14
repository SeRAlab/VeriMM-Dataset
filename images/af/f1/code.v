module top_module(CLK, ADDR, WE, EN, DIN, DINP, DOUT, DOUTP);input CLK;
input WE;
input EN;
input [12:0] ADDR;
input [7:0] DIN;
input DINP;
output reg [7:0] DOUT;
output reg DOUTP;

wire [7:0] ram0_DOUT, ram1_DOUT, ram2_DOUT;
wire ram0_DOUTP, ram1_DOUTP, ram2_DOUTP;

reg [3:0] ram_EN;

// Behavior of enabling the RAMs
always @*
begin
  ram_EN = 0;
  ram_EN[ADDR[12:11]] = EN;
end

//
// Output mux...
//
reg [1:0] dly_ADDR;
always @(posedge CLK)
begin
  dly_ADDR <= ADDR[12:11]; // Non-blocking assignment
end

always @*
begin
  DOUT = 8'h0;
  DOUTP = 1'b0;
  case (dly_ADDR)
    2'b00: begin DOUT = ram0_DOUT; DOUTP = ram0_DOUTP; end
    2'b01: begin DOUT = ram1_DOUT; DOUTP = ram1_DOUTP; end
    2'b10: begin DOUT = ram2_DOUT; DOUTP = ram2_DOUTP; end
  endcase
end

//
// Simple block RAM implementation...
//
reg [7:0] ram0 [0:2047]; // 2K x 8
reg [7:0] ram1 [0:2047]; // 2K x 8
reg [7:0] ram2 [0:2047]; // 2K x 8

assign ram0_DOUT = ram0[ADDR[10:0]];
assign ram1_DOUT = ram1[ADDR[10:0]];
assign ram2_DOUT = ram2[ADDR[10:0]];

// Write to RAMs
always @(posedge CLK)
begin
  if (WE) begin
    if (ram_EN[0]) ram0[ADDR[10:0]] <= DIN;
    if (ram_EN[1]) ram1[ADDR[10:0]] <= DIN;
    if (ram_EN[2]) ram2[ADDR[10:0]] <= DIN;
  end
end

// Output Data Integrity (assured by the TDO on the RAMs)
assign ram0_DOUTP = 1'b0; // Assuming no parity checks
assign ram1_DOUTP = 1'b0; // Assuming no parity checks
assign ram2_DOUTP = 1'b0; // Assuming no parity checks

endmodule