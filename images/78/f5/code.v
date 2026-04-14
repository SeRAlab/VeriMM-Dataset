module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter A = 3'b001, B = 3'b010, C = 3'b100;
  reg [2:0] state, next_state;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end
  
  always @ (*) begin
    case (state)
      A: begin
        if (data == 2'b10) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if (data == 1'b1) begin
          next_state = C;
        end else if (data == 1'b0) begin
          next_state = A;
        end
      end
      C: begin
        next_state = C;
      end
    endcase
  end
  
  always @ (state) begin
    if (state == C) begin
      match = 1'b1;
    end else begin
      match = 1'b0;
    end
  end
  
endmodule