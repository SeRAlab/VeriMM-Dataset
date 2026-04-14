module top_module(
    input clk,
    input ena,
    input w,
    input [3:0] wb,
    input [13:0] a,
    input [31:0] d,
    output reg [31:0] q
);// 8192 x 8 RAMs with byte-write enables ($0000..$7FFF)
reg [7:0] ram3 [8191:0];
reg [7:0] ram2 [8191:0];
reg [7:0] ram1 [8191:0];
reg [7:0] ram0 [8191:0];

reg [7:0] ram_q3;
reg [7:0] ram_q2;
reg [7:0] ram_q1;
reg [7:0] ram_q0;

always @(posedge clk)
begin
    if (ena && !a[13] && w && wb[3])
        ram3[a[12:0]] <= d[31:24];
    if (ena && !a[13])
        ram_q3 <= ram3[a[12:0]];
end

always @(posedge clk)
begin
    if (ena && !a[13] && w && wb[2])
        ram2[a[12:0]] <= d[23:16];
    if (ena && !a[13])
        ram_q2 <= ram2[a[12:0]];
end

always @(posedge clk)
begin
    if (ena && !a[13] && w && wb[1])
        ram1[a[12:0]] <= d[15:8];
    if (ena && !a[13])
        ram_q1 <= ram1[a[12:0]];
end

always @(posedge clk)
begin
    if (ena && !a[13] && w && wb[0])
        ram0[a[12:0]] <= d[7:0];
    if (ena && !a[13])
        ram_q0 <= ram0[a[12:0]];
end

// 4096 x 32 ROM containing character definitions ($8000..$BFFF)
(* ram_init_file = "hub_rom_low.hex" *) reg [31:0] rom_low [4095:0];

reg [31:0] rom_low_q;

always @(posedge clk)
if (ena && a[13:12] == 2'b10)
    rom_low_q <= rom_low[a[11:0]];

// 4096 x 32 ROM containing sin table, log table, booter, and interpreter ($C000..$FFFF)
(* ram_init_file = "hub_rom_high.hex" *) reg [31:0] rom_high [4095:0];

reg [31:0] rom_high_q;

always @(posedge clk)
if (ena && a[13:12] == 2'b11)
    rom_high_q <= rom_high[a[11:0]];

// Memory output mux
reg [1:0] mem;

always @(posedge clk)
if (ena)
    mem <= a[13:12];

assign q = !mem[1] ? {ram_q3, ram_q2, ram_q1, ram_q0} : rom_high_q;

endmodule