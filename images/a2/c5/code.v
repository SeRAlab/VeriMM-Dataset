module top_module(
  input in1,
  input in2,
  input in3,
  output reg out1,
  output reg out2
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  // Define the current state
  reg [1:0] state = S0;
  
  always @(*) begin
    // Priority encoding logic
    if (in1) begin
      state = S0;
    end else if (in2) begin
      state = S1;
    end else if (in3) begin
      state = S2;
    end else begin
      state = S3;
    end
    
    // Set the output signals based on the current state
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
      S3: begin
        out1 = 0;
        out2 = 0;
      end
    endcase
  end

endmodule