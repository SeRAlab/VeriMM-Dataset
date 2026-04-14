module top_module(address,is_sector1_writable,is_sector2_writable,is_sector3_writable,is_sector4_writable,is_sector5_writable,is_addr_writable);input [2:0] address; 
  input is_sector1_writable; 
  input is_sector2_writable; 
  input is_sector3_writable; 
  input is_sector4_writable; 
  input is_sector5_writable; 
  output is_addr_writable; 
  wire is_sector1_addr; 
  wire is_sector2_addr; 
  wire is_sector3_addr; 
  wire is_sector4_addr; 
  wire is_sector5_addr; 
  assign is_sector1_addr = (address == 1); 
  assign is_sector2_addr = (address == 2); 
  assign is_sector3_addr = (address == 3); 
  assign is_sector4_addr = (address == 4); 
  assign is_sector5_addr = (address == 5); 
 assign is_addr_writable = ((is_sector1_writable && is_sector1_addr) ||(is_sector2_writable && is_sector2_addr) ||(is_sector3_writable && is_sector3_addr) ||(is_sector4_writable && is_sector4_addr) ||(is_sector5_writable && is_sector5_addr)); 
 endmodule