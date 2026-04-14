module top_module(douta,
     clka,
     addra,
     dina,
     wea);output reg [11:0] douta;  // Changed to reg type for synchronous assignment
  input clka;
  input [10:0] addra;
  input [11:0] dina;
  input [0:0] wea;

  reg [11:0] memory [0:2047];

  always @(posedge clka) begin
    if (wea) begin
      memory[addra] <= dina;
    end
    douta <= memory[addra];
  end

  // Removed the instantiation of bg_low_blk_mem_gen_top as it is not defined
  // Ensure to include the valid definition in the appropriate place if needed
  
endmodule