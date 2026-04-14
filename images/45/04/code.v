module top_module(
  input clk,
  input reset,
  input data,
  output reg [3:0] count,
  output reg output_data
);parameter STATE_0 = 2'b00;
  parameter STATE_1 = 2'b01;
  
  reg [1:0] state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= STATE_0;
      count <= 0;
      output_data <= 0;
    end
    else begin
      case (state)
        STATE_0: begin
          if (data) begin
            state <= STATE_1;
            count <= 1;
          end
          else begin
            state <= STATE_0;
            output_data <= 0;
          end
        end
        STATE_1: begin
          if (data) begin
            state <= STATE_1;
            count <= count + 1;
          end
          else begin
            state <= STATE_0;
            output_data <= 1;
          end
        end
      endcase
    end
  end
  
endmodule