module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);reg [1:0] state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      count <= 4'b0000;
    end else begin
      case (state)
        2'b00: begin
          if (enable) begin
            state <= 2'b01;
            count <= count + 1;
          end
        end
        2'b01: begin
          if (enable) begin
            state <= 2'b10;
            count <= count + 1;
          end else begin
            state <= 2'b00;
          end
        end
        2'b10: begin
          if (enable) begin
            state <= 2'b11;
            count <= count + 1;
          end else begin
            state <= 2'b00;
          end
        end
        2'b11: begin
          if (enable) begin
            state <= 2'b01;
            count <= count + 1;
          end else begin
            state <= 2'b00;
          end
        end
      endcase
    end
  end
endmodule