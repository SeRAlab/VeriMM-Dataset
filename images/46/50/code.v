module top_module(
    input clk,
    input ce,
    input reset,
    input [31:0] flags,
    input [15:0] prg_ain,
    output [21:0] prg_aout,
    input prg_read,
    input prg_write,
    input [7:0] prg_din,
    output prg_allow,
    input [13:0] chr_ain,
    output [21:0] chr_aout,
    output chr_allow,
    output vram_a10,
    output vram_ce
);reg [3:0] prg_bank;
  reg ciram_select;
  wire mapper232 = (flags[7:0] == 232);
  reg [3:0] prgout;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      prg_bank <= 0;
      ciram_select <= 0;
    end else if (ce) begin
      if (prg_ain[15] && prg_write) begin
        $write("%X <= %X (bank = %x)\n", prg_ain, prg_din, prg_bank);
        if (!prg_ain[14] && mapper232) 
          prg_bank[3:2] <= prg_din[4:3];
        if (prg_ain[14:13] == 0) 
          ciram_select <= prg_din[4];
        if (prg_ain[14]) 
          prg_bank <= {mapper232 ? prg_bank[3:2] : prg_din[3:2], prg_din[1:0]};
      end
    end
  end

  always @* begin // Changed to combinational logic
    casez({prg_ain[14], mapper232}) 
      2'b0?: prgout = prg_bank; 
      2'b10: prgout = 4'b1111; 
      2'b11: prgout = {prg_bank[3:2], 2'b11}; 
    endcase 
  end

  assign prg_aout = {4'b00_00, prgout, prg_ain[13:0]};
  assign prg_allow = prg_ain[15] && !prg_write;
  assign chr_allow = flags[15];
  assign chr_aout = {9'b10_0000_000, chr_ain[12:0]};
  assign vram_ce = chr_ain[13];
  assign vram_a10 = flags[14] ? chr_ain[10] : ciram_select;

endmodule