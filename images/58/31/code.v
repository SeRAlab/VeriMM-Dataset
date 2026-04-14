module top_module(
  input clk,
  input reset,
  output reg [3:0] count
);// Define the four states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  // Define the state register and initialize to S0
  reg [1:0] state = S0;
  
  // Define the next state logic
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
    end else begin
      case (state)
        S0: state <= S1;
        S1: state <= S2;
        S2: state <= S3;
        S3: state <= S0;
      endcase
    end
  end
  
  // Define the output logic
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0000;
    end else begin
      case (state)
        S0: count <= count + 4'b0001;
        S1: count <= count + 4'b0001;
        S2: count <= count + 4'b0001;
        S3: count <= count + 4'b0001;
      endcase
    end
  end
  
endmodule