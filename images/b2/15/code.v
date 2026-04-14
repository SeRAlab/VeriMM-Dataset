module top_module(
  input clk_i,
  input rst_i,
  input write_i,
  input discard_pixel,
  input zbuffer_enable_i,
  input z_ack_i,
  input fail_z_check,
  output reg write_o,
  output reg ack_o
);// State machine states
  parameter wait_state = 2'b00;
  parameter z_read_state = 2'b01;
  parameter write_pixel_state = 2'b10;

  // State machine
  reg [1:0] state;

  always @(posedge clk_i or posedge rst_i)
    // reset, init component
    if(rst_i)
      state <= wait_state;
    // Move in state machine
    else
      case (state)
        wait_state:
          if(write_i && !discard_pixel)
          begin
            if(zbuffer_enable_i)
              state <= z_read_state;
            else 
              state <= write_pixel_state;
          end

        z_read_state:
          if(z_ack_i)
            state <= fail_z_check ? wait_state : write_pixel_state;

        write_pixel_state:
          if(ack_o) // Changed 'ack_i' to 'ack_o'
            state <= wait_state;

      endcase

  // Write and ack signals
  always @(state)
    case (state)
      wait_state:
        begin
          write_o <= 1'b0;
          ack_o <= 1'b0;
        end

      z_read_state:
        begin
          write_o <= 1'b0;
          ack_o <= 1'b0;
        end

      write_pixel_state:
        begin
          write_o <= 1'b1;
          ack_o <= 1'b0;
        end
    endcase

  // Acknowledge signal
  always @(posedge clk_i)
    if(state == write_pixel_state)
      ack_o <= 1'b1;
    else
      ack_o <= 1'b0; // Ensured that ack_o is reset when not in write_pixel_state

endmodule