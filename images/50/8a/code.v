module top_module(
    
    input clk,
    input rst,

    
    input      [7:0] wb_dat_i,
    output reg [7:0] wb_dat_o,
    input            wb_we_i,
    input            wb_stb_i,
    input            wb_cyc_i,
    output           wb_ack_o,

    
    input timer2,

    
    output speaker_
  );wire        write;
  wire        spk;

  
  
  assign speaker_ = timer2 & wb_dat_o[1];

  
  assign wb_ack_o = wb_stb_i && wb_cyc_i;
  assign write    = wb_stb_i && wb_cyc_i && wb_we_i;

  
  always @(posedge clk)
    wb_dat_o <= rst ? 8'h0 : (write ? wb_dat_i : wb_dat_o);

endmodule