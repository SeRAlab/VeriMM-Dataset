module top_module(
  input clk, // clock signal
  input en, // control signal
  input [7:0] d, // data signals
  output rs, // register select
  output rw, // read/write
  output e // enable
);// Define state machine states
  parameter IDLE = 2'b00;
  parameter WRITE_COMMAND = 2'b01;
  parameter WRITE_DATA = 2'b10;

  // Define state machine signals
  reg [1:0] state;
  reg [7:0] data_out;
  reg rs_out;
  reg rw_out;
  reg e_out;

  // Initialize state machine
  initial begin
    state = IDLE;
    data_out = 8'b0;
    rs_out = 1'b0;
    rw_out = 1'b0;
    e_out = 1'b0;
  end

  // Define state machine transitions
  always @(posedge clk) begin
    case(state)
      IDLE: begin
        if(en) begin
          if(d[7:6] == 2'b00) begin
            rs_out = 1'b0; // Select command register
            rw_out = 1'b0; // Write operation
            data_out = d; // Set data to be written
            e_out = 1'b1; // Enable write operation
            state = WRITE_COMMAND; // Transition to write command state
          end
          else begin
            rs_out = 1'b1; // Select data register
            rw_out = 1'b0; // Write operation
            data_out = d; // Set data to be written
            e_out = 1'b1; // Enable write operation
            state = WRITE_DATA; // Transition to write data state
          end
        end
      end

      WRITE_COMMAND: begin
        e_out = 1'b0; // Disable write operation
        state = IDLE; // Transition to idle state
      end

      WRITE_DATA: begin
        e_out = 1'b0; // Disable write operation
        state = IDLE; // Transition to idle state
      end
    endcase
  end

  // Assign output signals
  assign rs = rs_out;
  assign rw = rw_out;
  assign e = e_out;

endmodule