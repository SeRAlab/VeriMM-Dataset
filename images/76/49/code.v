module top_module(
  input [15:0] data,
  input [2:0] ctrl,
  input en,
  output [6:0] addr,
  output rw,
  output rs,
  output rst
);// Define control signals
  reg [2:0] cmd;
  reg [3:0] state;
  reg [15:0] lcd_data;
  reg [6:0] lcd_addr;
  reg lcd_rw;
  reg lcd_rs;
  reg lcd_rst;
  
  // Define timing parameters
  parameter t_setup = 10;
  parameter t_hold = 10;
  parameter t_pulse = 10;
  parameter t_wait = 100;
  
  // Define state machine
  localparam IDLE = 0, SEND_CMD = 1, SEND_DATA = 2, WAIT = 3;
  
  always @ (posedge en) begin
    if (ctrl == 3'b000) begin // Clear display
      cmd <= 3'b000;
      state <= SEND_CMD;
    end else if (ctrl == 3'b001) begin // Set cursor position
      cmd <= 3'b001;
      state <= SEND_CMD;
    end else if (ctrl == 3'b010) begin // Send data
      cmd <= 3'b010;
      state <= SEND_DATA;
    end else begin
      state <= IDLE;
    end
  end
  
  always @ (posedge en) begin
    case (state)
      IDLE: begin
        lcd_rw <= 1'b0;
        lcd_rs <= 1'b0;
        lcd_rst <= 1'b0;
        lcd_addr <= 7'b0000000;
        lcd_data <= 16'b0;
      end
      SEND_CMD: begin
        lcd_rw <= 1'b0;
        lcd_rs <= 1'b0;
        lcd_rst <= 1'b0;
        lcd_addr <= 7'b0000000;
        lcd_data <= {8'b0, cmd};
        state <= WAIT;
      end
      SEND_DATA: begin
        lcd_rw <= 1'b0;
        lcd_rs <= 1'b1;
        lcd_rst <= 1'b0;
        lcd_addr <= 7'b0000000;
        lcd_data <= {8'b0, data[7:0]};
        state <= WAIT;
      end
      WAIT: begin
        lcd_rw <= 1'b0;
        lcd_rs <= 1'b0;
        lcd_rst <= 1'b0;
        lcd_addr <= 7'b0000000;
        lcd_data <= 16'b0;
        state <= IDLE;
        #t_wait;
      end
      default: begin
        state <= IDLE;
      end
    endcase
  end
  
  // Assign outputs
  assign addr = lcd_addr;
  assign rw = lcd_rw;
  assign rs = lcd_rs;
  assign rst = lcd_rst;
  
endmodule