module top_module(
  // Primary SPI bus.
  input main_nss,
  input main_sck,
  input main_mosi,
  output main_miso,

  // Secondary SPI bus.
  input alt_nss,
  input alt_sck,
  input alt_mosi,
  output alt_miso,

  // Output SPI bus.
  output reg nss,
  output reg sck,
  output reg mosi,
  input miso
);// Each bus is granted access when its select is asserted and the other bus'
  // select is not asserted.
  wire alt_bus_enabled = (alt_nss == 'b0) & (main_nss == 'b1);
  wire main_bus_enabled = (alt_nss == 'b1) & (main_nss == 'b0);

  // Multiplex the two SPI buses.
  // nSS should be allowed to assert only if only one bus is asserting it.
  // This avoids undefined behavior when the main bus interrupts the secondary
  // bus.
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