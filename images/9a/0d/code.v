module top_module(
  input clk,                   // Added clock input
  input [7:0] temp,
  input [7:0] press,
  input [7:0] humid,
  input [1:0] sensor_select,   // Added sensor_select input
  output reg [7:0] temp_out,
  output reg [7:0] press_out,
  output reg [7:0] humid_out
);reg [7:0] temp_digital;
  reg [7:0] press_digital;
  reg [7:0] humid_digital;
  
  // Analog-to-digital conversion process for temperature sensor
  always @ (posedge clk) begin
    temp_digital <= temp * 8'hF3 / 8'hFF; // Calibration value of 0.488 -> 0.488 * 255 ~ 124
  end
  
  // Analog-to-digital conversion process for pressure sensor
  always @ (posedge clk) begin
    press_digital <= press * 8'hF0 / 8'hFF; // Calibration value of 0.244 -> 0.244 * 255 ~ 62
  end
  
  // Analog-to-digital conversion process for humidity sensor
  always @ (posedge clk) begin
    humid_digital <= humid * 8'hF8 / 8'hFF; // Calibration value of 0.976 -> 0.976 * 255 ~ 248
  end
  
  // Multiplexer to select between sensors and output corresponding digital reading
  always @ (posedge clk) begin
    case (sensor_select)
      2'b00: begin // Temperature sensor selected
        temp_out <= temp_digital;
        press_out <= 0;
        humid_out <= 0;
      end
      2'b01: begin // Pressure sensor selected
        temp_out <= 0;
        press_out <= press_digital;
        humid_out <= 0;
      end
      2'b10: begin // Humidity sensor selected
        temp_out <= 0;
        press_out <= 0;
        humid_out <= humid_digital;
      end
      default: begin // No sensor selected
        temp_out <= 0;
        press_out <= 0;
        humid_out <= 0;
      end
    endcase
  end

endmodule