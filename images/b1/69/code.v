module top_module(
  input clk,
  input reset,
  output reg [3:0] gray_code
);// Define the four states of the FSM
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define the state register and next state logic
  reg [1:0] state_reg, state_next;
  
  // Define the Gray code counter
  reg [3:0] gray_code_reg, gray_code_next;
  
  // Initialize the state and Gray code registers
  initial begin
    state_reg = S0;
    gray_code_reg = 4'b0000;
  end
  
  // Define the state transition logic
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state_reg <= S0;
      gray_code_reg <= 4'b0000;
    end else begin
      state_reg <= state_next;
      gray_code_reg <= gray_code_next;
    end
  end
  
  // Define the next state and Gray code logic
  always @ (state_reg, gray_code_reg) begin
    case (state_reg)
      S0: begin
        state_next = S1;
        gray_code_next = 4'b0001;
      end
      S1: begin
        state_next = S2;
        gray_code_next = 4'b0011;
      end
      S2: begin
        state_next = S3;
        gray_code_next = 4'b0010;
      end
      S3: begin
        state_next = S0;
        gray_code_next = 4'b0110;
      end
    endcase
    
    // Wrap around to zero after reaching 15
    if (gray_code_reg == 4'b1111) begin
      gray_code_next = 4'b0000;
    end
  end
  
  // Assign the Gray code output
  assign gray_code = gray_code_reg;

endmodule