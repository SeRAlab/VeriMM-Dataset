module top_module(
  input clk,
  input start,
  input reset,
  input [7:0] vin,
  output reg [7:0] dout,
  output reg busy
);reg [7:0] count;
  reg [7:0] approx;
  reg [7:0] temp;

  parameter IDLE = 2'b00;
  parameter BUSY = 2'b01;
  parameter DONE = 2'b10;

  reg [1:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      count <= 0;
      approx <= 0;
      dout <= 0;
      busy <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          if (start) begin
            state <= BUSY;
            count <= 0;
            approx <= 128;
            busy <= 1;
          end
        end
        BUSY: begin
          if (count == 8) begin
            state <= DONE;
            busy <= 0;
            dout <= approx;
          end
          else begin
            temp <= {approx[7], approx[6], approx[5], approx[4], approx[3], approx[2], approx[1], approx[0]};
            if (temp >= vin) begin
              approx <= {approx[7:1], 1'b0}; // Fixed the concatenation width
            end
            else begin
              approx <= {approx[7:1], 1'b1}; // Fixed the concatenation width
            end
            count <= count + 1;
          end
        end
        DONE: begin
          if (!start) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

endmodule