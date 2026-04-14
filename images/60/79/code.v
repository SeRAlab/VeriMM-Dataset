module top_module(
  input clk,
  input rst,
  input in1,
  input in2,
  output reg out1,
  output reg out2
);// Define your states and state variables here
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  
  reg [1:0] state;
  
  // Define your outputs as a function of the current state
  always @ (state) begin
    case (state)
      S0: begin
        out1 = 1;
        out2 = 0;
      end
      S1: begin
        out1 = 0;
        out2 = 1;
      end
      S2: begin
        out1 = 1;
        out2 = 1;
      end
    endcase
  end
  
  // Define the state transitions based on the inputs and the current state
  always @ (posedge clk, posedge rst) begin
    if (rst) begin
      state <= S0;
    end else begin
      case (state)
        S0: begin
          if (in1) begin
            state <= S1;
          end else if (in2) begin
            state <= S2;
          end
        end
        S1: begin
          if (in2) begin
            state <= S2;
          end else if (!in1) begin
            state <= S0;
          end
        end
        S2: begin
          if (!in1 && !in2) begin
            state <= S0;
          end
        end
      endcase
    end
  end
  
endmodule