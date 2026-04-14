module top_module(
  input CLK,
  input [23:0] SNES_ADDR,   
  output [23:0] ROM_ADDR,   
  output ROM_HIT,           
  output IS_SAVERAM,        
  output IS_ROM,            
  input [23:0] SAVERAM_MASK,
  input [23:0] ROM_MASK
);wire [23:0] SRAM_SNES_ADDR;





assign IS_ROM = ((!SNES_ADDR[22] & SNES_ADDR[15])
                 |(SNES_ADDR[22]));

assign IS_SAVERAM = (!SNES_ADDR[22]
                     & &SNES_ADDR[21:20]
                     & &SNES_ADDR[14:13]
                     & !SNES_ADDR[15]
                    );

assign SRAM_SNES_ADDR = (IS_SAVERAM
                             ? 24'hFF0000 + ((SNES_ADDR[14:0] - 15'h6000)
                                             & SAVERAM_MASK)
                             : (({1'b0, SNES_ADDR[22:0]} & ROM_MASK)
                                + 24'hC00000)
                        );

assign ROM_ADDR = SRAM_SNES_ADDR;

assign ROM_HIT = IS_ROM | IS_SAVERAM;

endmodule