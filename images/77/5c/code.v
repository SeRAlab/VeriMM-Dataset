module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg [1:0] count
);reg [1:0] state;
  
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      state <= 2'b00;
      count <= 2'b00;
    end
    else begin
      case (state)
        2'b00: begin
          if (data == 4'b0001) begin
            state <= 2'b01;
            count <= 2'b01;
          end
          else begin
            state <= 2'b00;
            count <= 2'b00;
          end
        end
        2'b01: begin
          if (data == 4'b0011) begin
            state <= 2'b10;
            count <= 2'b10;
          end
          else if (data == 4'b0001) begin
            state <= 2'b01;
            count <= 2'b01;
          end
          else begin
            state <= 2'b00;
            count <= 2'b00;
          end
        end
        2'b10: begin
          state <= 2'b00;
          count <= 2'b00;
        end
        default: begin
          state <= 2'b00;
          count <= 2'b00;
        end
      endcase
    end
  end
  
endmodule