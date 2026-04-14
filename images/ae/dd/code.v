module top_module(
    input clk,
    input en,
    input w,
    input [3:0] wbe,
    input [13:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);// 2KB character ROM
reg [31:0] rom_low [2047:0];
(* ram_init_file = "character_rom.hex" *) // initialize ROM with character definitions

// 2KB sin table, log table, booter, and interpreter ROM
reg [31:0] rom_high [2047:0];
(* ram_init_file = "sin_log_booter_interpreter.hex" *) // initialize ROM with sin table, log table, booter, and interpreter

// 4KB RAM
reg [7:0] ram3 [2047:0];
reg [7:0] ram2 [2047:0];
reg [7:0] ram1 [2047:0];
reg [7:0] ram0 [2047:0];

reg [7:0] ram_q3;
reg [7:0] ram_q2;
reg [7:0] ram_q1;
reg [7:0] ram_q0;

always @(posedge clk)
begin
    if (en && !addr[13] && w && wbe[3])
        ram3[addr[12:0]] <= data_in[31:24];
    if (en && !addr[13])
        ram_q3 <= ram3[addr[12:0]];
end

always @(posedge clk)
begin
    if (en && !addr[13] && w && wbe[2])
        ram2[addr[12:0]] <= data_in[23:16];
    if (en && !addr[13])
        ram_q2 <= ram2[addr[12:0]];
end

always @(posedge clk)
begin
    if (en && !addr[13] && w && wbe[1])
        ram1[addr[12:0]] <= data_in[15:8];
    if (en && !addr[13])
        ram_q1 <= ram1[addr[12:0]];
end

always @(posedge clk)
begin
    if (en && !addr[13] && w && wbe[0])
        ram0[addr[12:0]] <= data_in[7:0];
    if (en && !addr[13])
        ram_q0 <= ram0[addr[12:0]];
end

always @(posedge clk)
begin
    if (en && addr[13:12] == 2'b10)
        data_out <= rom_low[addr[11:0]];
end

always @(posedge clk)
begin
    if (en && addr[13:12] == 2'b11)
        data_out <= rom_high[addr[11:0]];
end

always @(posedge clk)
begin
    if (en)
    begin
        case (addr[13:12])
            2'b00: data_out <= {ram_q3, ram_q2, ram_q1, ram_q0};
            2'b10: data_out <= rom_low[addr[11:0]];
            2'b11: data_out <= rom_high[addr[11:0]];
            default: data_out <= 32'hx;
        endcase
    end
end

endmodule