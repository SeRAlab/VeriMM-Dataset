module top_module(
  input master_read_done_token,
  input master_write_done_token,
  input slave_clk,
  input slave_read,
  input slave_reset_n,
  input slave_write,
  output reg slave_read_request,
  output reg slave_waitrequest,
  output reg slave_write_request
);reg [2:0] slave_state, next_slave_state;
  reg next_slave_read_request, next_slave_write_request;

  parameter IDLE = 3'b001;
  parameter READ_WAIT = 3'b010;
  parameter WRITE_WAIT = 3'b100;

  always @(posedge slave_clk or negedge slave_reset_n) begin
    if (~slave_reset_n) begin
      slave_state <= IDLE;
      slave_read_request <= 0;
      slave_waitrequest <= 0;
      slave_write_request <= 0;
    end else begin
      slave_state <= next_slave_state;
      slave_read_request <= next_slave_read_request;
      slave_waitrequest <= (slave_state == READ_WAIT || slave_state == WRITE_WAIT);
      slave_write_request <= next_slave_write_request;
    end
  end

  always @(*) begin
    next_slave_state = slave_state;
    next_slave_read_request = slave_read_request;
    next_slave_write_request = slave_write_request;

    case (slave_state)
      IDLE: begin
        if (slave_read) begin
          next_slave_state = READ_WAIT;
          next_slave_read_request = 1;
        end else if (slave_write) begin
          next_slave_state = WRITE_WAIT;
          next_slave_write_request = 1;
        end
      end
      READ_WAIT: begin
        if (master_read_done_token) begin
          next_slave_state = IDLE;
          next_slave_read_request = 0;
        end
      end
      WRITE_WAIT: begin
        if (master_write_done_token) begin
          next_slave_state = IDLE;
          next_slave_write_request = 0;
        end
      end
    endcase
  end

endmodule