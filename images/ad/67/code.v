module top_module(
  input in1,
  input in2,
  input clk,
  input reset,
  output reg out1,
  output reg out2
);reg [1:0] state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      out1 <= 1'b0;
      out2 <= 1'b0;
    end
    else begin
      case (state)
        2'b00: begin // S0
          out1 <= 1'b0;
          out2 <= 1'b0;
          if (in1) state <= 2'b01;
        end
        2'b01: begin // S1
          out1 <= 1'b0;
          out2 <= 1'b0;
          if (in1) state <= 2'b10;
        end
        2'b10: begin // S2
          out1 <= 1'b1;
          out2 <= 1'b0;
          if (!in2) state <= 2'b11;
        end
        2'b11: begin // S3
          out1 <= 1'b1;
          out2 <= 1'b1;
          if (in2) state <= 2'b00;
        end
      endcase
    end
  end
  
endmodule