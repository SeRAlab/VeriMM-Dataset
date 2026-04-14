module top_module(byte_access,hw,write_address,write_byteenable);output [ 1: 0] write_byteenable; 
  input byte_access; 
  input hw; 
  input [ 25: 0] write_address; 
  wire wa_0_is_0; 
  wire wa_0_is_1; 
  wire [ 1: 0] write_byteenable; 
  assign wa_0_is_1 = write_address[0] == 1'h1; 
  assign wa_0_is_0 = write_address[0] == 1'h0; 
  assign write_byteenable = ({2 {byte_access}} & {wa_0_is_1, wa_0_is_0}) | 
  ({2 {hw}} & 2'b11); 
 endmodule