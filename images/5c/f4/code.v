module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter State1 = 2'b00;
  parameter State2 = 2'b01;
  parameter State3 = 2'b10;
  
  reg [1:0] state;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= State1;
      match <= 1'b0;
    end else begin
      case (state)
        State1: begin
          if (data == 1'b1) begin
            state <= State2;
          end else begin
            state <= State1;
          end
        end
        State2: begin
          if (data == 1'b0) begin
            state <= State3;
          end else begin
            state <= State1;
          end
        end
        State3: begin
          if (data == 1'b1) begin
            state <= State1;
            match <= 1'b1;
          end else begin
            state <= State1;
          end
        end
      endcase
    end
  end
  
endmodule