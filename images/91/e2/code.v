module top_module(
  input PLLIN,
  output reg PLLOUTCORE,
  output reg PLLOUTGLOBAL,
  input EXTFEEDBACK,
  input [7:0] DYNAMICDELAY,
  output reg LOCK,
  input BYPASS,
  input RESETB,
  input SCLK,
  input SDI,
  output reg SDO,
  input LATCHINPUTVALUE
);reg [7:0] delay_counter;
  reg [7:0] feedback_counter;
  reg [7:0] config_counter;
  reg [7:0] config_data;
  reg [23:0] shift_register; // Change: Declare as a 24-bit reg instead of reg array

  assign PLLOUTCORE = PLLIN;
  assign PLLOUTGLOBAL = shift_register[23];

  always @(posedge PLLIN or negedge RESETB) begin
    if (!RESETB) begin
      delay_counter <= 0;
      feedback_counter <= 0;
      config_counter <= 0;
      config_data <= 0;
      shift_register <= 0; // Initialize the whole shift_register
      SDO <= 0;
      LOCK <= 0;
    end else begin
      delay_counter <= delay_counter + 1;
      feedback_counter <= feedback_counter + 1;
      config_counter <= config_counter + 1;

      if (config_counter == 7) begin
        config_data <= {SDI, config_data[7:1]};
        SDO <= config_data[7];
      end

      if (BYPASS) begin
        shift_register <= {shift_register[22:0], PLLIN};
        LOCK <= 1;
      end else begin
        if (feedback_counter == DYNAMICDELAY) begin
          feedback_counter <= 0;
          shift_register <= {shift_register[22:0], shift_register[23] ^ shift_register[16] ^ shift_register[12] ^ shift_register[5]};
        end

        if (delay_counter == DYNAMICDELAY) begin
          delay_counter <= 0;
          LOCK <= (shift_register[23] == PLLIN);
        end
      end
    end
  end

  always @(posedge SCLK) begin
    if (LATCHINPUTVALUE == 1) begin
      delay_counter <= 0;
      feedback_counter <= 0;
      config_counter <= 0;
      config_data <= 0;
      shift_register <= 0; // Initialize the whole shift_register
      SDO <= 0;
      LOCK <= 0;
    end
  end

endmodule