module top_module(
  input [n-1:0] data,
  input RS,
  input RW,
  input E,
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output reg [7:0] LCD_D // Changed wire to reg
);parameter n = 8; // number of data signals (8 for an 8-bit LCD interface)

// Define the commands and data that are sent to the LCD screen
parameter CLEAR_DISPLAY = 8'h01;
parameter RETURN_HOME = 8'h02;
parameter ENTRY_MODE_SET = 8'h04;
parameter DISPLAY_ON_OFF_CONTROL = 8'h08;
parameter CURSOR_DISPLAY_SHIFT = 8'h10;
parameter FUNCTION_SET = 8'h20;
parameter SET_CGRAM_ADDRESS = 8'h40;
parameter SET_DDRAM_ADDRESS = 8'h80;

// Define the output signals that control the LCD screen
assign LCD_RS = RS;
assign LCD_RW = RW;
assign LCD_E = E;

// Send commands and data to the LCD screen
always @(posedge E) begin
  if (RS == 0 && RW == 0) begin // Command
    case (data)
      CLEAR_DISPLAY: LCD_D <= 8'h01;
      RETURN_HOME: LCD_D <= 8'h02;
      ENTRY_MODE_SET: LCD_D <= 8'h04;
      DISPLAY_ON_OFF_CONTROL: LCD_D <= 8'h08;
      CURSOR_DISPLAY_SHIFT: LCD_D <= 8'h10;
      FUNCTION_SET: LCD_D <= 8'h20;
      SET_CGRAM_ADDRESS: LCD_D <= 8'h40;
      SET_DDRAM_ADDRESS: LCD_D <= 8'h80;
      default: LCD_D <= 8'h00;
    endcase
  end else begin // Data
    LCD_D <= data;
  end
end

endmodule