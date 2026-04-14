module dram_cell (input wire D, input wire WL, input wire BL, output reg Q);  
  reg stored_bit;  
  
  always @(posedge WL) begin  
    stored_bit <= D;  
  end  
  
  always @(posedge BL) begin  
    Q <= stored_bit;  
  end  
endmodule