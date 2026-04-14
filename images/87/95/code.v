module top_module(input main_nss,input main_sck,input main_mosi,output main_miso,input alt_nss,input alt_sck,input alt_mosi,output alt_miso,output reg nss,output reg sck,output reg mosi,input miso);wire alt_bus_enabled = (alt_nss == 'b0) & (main_nss == 'b1); 
  wire main_bus_enabled = (alt_nss == 'b1) & (main_nss == 'b0); 
  always @ (*) begin 
  if (alt_bus_enabled) begin 
  nss <= 'b0; 
  sck <= alt_sck; 
  mosi <= alt_mosi; 
  end else if (main_bus_enabled) begin 
  nss <= 'b0; 
  sck <= main_sck; 
  mosi <= main_mosi; 
  end else begin 
  nss <= 'b1; 
  sck <= 0; 
  mosi <= 0; 
  end 
  end 
  assign main_miso = (main_nss == 'b0) ? miso : 'bz; 
  assign alt_miso = (alt_nss == 'b0) ? miso : 'bz; 
 endmodule