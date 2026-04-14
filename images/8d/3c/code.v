module top_module(
  input clk,
  input reset,
  input x,
  input [5:0] y,
  output Y2,
  output Y4
);reg [5:0] state, next_state;
  reg [5:0] Y;
  
  parameter A = 6'b000001;
  parameter B = 6'b000010;
  parameter C = 6'b000100;
  parameter D = 6'b001000;
  parameter E = 6'b010000;
  parameter F = 6'b100000;
  
  // State transition logic
  always @ (posedge clk) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end
  
  always @ (state, x) begin
    case (state)
      A: begin
        if (x) begin
          next_state = B;
        end else begin
          next_state = C;
        end
      end
      
      B: begin
        if (x) begin
          next_state = C;
        end else begin
          next_state = D;
        end
      end
      
      C: begin
        if (x) begin
          next_state = D;
        end else begin
          next_state = E;
        end
      end
      
      D: begin
        if (x) begin
          next_state = E;
        end else begin
          next_state = F;
        end
      end
      
      E: begin
        if (x) begin
          next_state = F;
        end else begin
          next_state = A;
        end
      end
      
      F: begin
        if (x) begin
          next_state = A;
        end else begin
          next_state = B;
        end
      end
    endcase
  end
  
  // Output logic
  always @ (state) begin
    case (state)
      A: Y = A;
      B: Y = B;
      C: Y = C;
      D: Y = D;
      E: Y = E;
      F: Y = F;
    endcase
  end
  
  assign Y2 = Y[2];
  assign Y4 = Y[4];
  
endmodule