module top_module(
  input clk,
  input reset,
  input data,
  output reg count
);reg [1:0] state;
  parameter IDLE = 2'b00, COUNTING = 2'b01;
  
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      state <= IDLE;
      count <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data == 1) begin
            state <= COUNTING;
            count <= 1;
          end
        end
        COUNTING: begin
          if (data == 1) begin
            count <= count + 1;
          end else begin
            state <= IDLE;
            count <= count;
          end
        end
      endcase
    end
  end
endmodule