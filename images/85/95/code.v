module top_module(
  input clk,
  input rst,
  input sat_data,
  input antenna_data,
  output reg [31:0] lat,
  output reg [31:0] lon,
  output reg [31:0] alt
);// Internal signals and registers
  reg [31:0] local_clock;
  reg [31:0] satellite_position;
  reg [31:0] receiver_position;
  reg [31:0] navigation_data;

  // Acquisition process
  always @(posedge rst) begin
    // Initialize local clock and search for satellite signals
    local_clock <= 0;
    satellite_position <= sat_data;
    receiver_position <= antenna_data;
  end

  // Tracking process
  always @(posedge clk) begin
    // Adjust local clock to maintain synchronization with GPS time
    local_clock <= local_clock + 1;

    // Update satellite and receiver positions
    satellite_position <= satellite_position + sat_data;
    receiver_position <= receiver_position + antenna_data;
  end

  // Navigation process
  always @(posedge clk) begin
    // Compute position of the receiver using navigation equations
    navigation_data <= satellite_position - receiver_position;

    // Update latitude, longitude, and altitude
    lat <= navigation_data[31:20];
    lon <= navigation_data[19:8];
    alt <= navigation_data[7:0];
  end

endmodule