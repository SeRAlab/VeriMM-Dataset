module top_module(
  input clk,
  input in,
  output reg[2:0] count
);reg d_last;
  reg[1:0] state;

  parameter IDLE = 2'b00;
  parameter COUNT = 2'b01;

  always @(posedge clk) begin
    case(state)
      IDLE:
        if(in && !d_last) begin
          state <= COUNT;
          count <= 0;
        end
      COUNT:
        if(in && !d_last) begin
          if(count == 4) begin
            state <= IDLE;
          end
          else begin
            count <= count + 1;
          end
        end
        else begin
          state <= IDLE;
        end
    endcase
    d_last <= in;
  end

endmodule