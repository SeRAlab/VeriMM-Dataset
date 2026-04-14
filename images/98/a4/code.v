module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg match
);parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  reg [1:0] state;
  reg [1:0] next_state;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S0;
      match <= 0;
    end
    else begin
      state <= next_state;
      match <= (state == S3);
    end
  end
  
  always @* begin
    case (state)
      S0: begin
        if (data == 4'b1_0_1_0)
          next_state = S1;
        else
          next_state = S0;
      end
      
      S1: begin
        if (data[2:0] == 3'b010)
          next_state = S2;
        else if (data == 4'b1_0_1_0)
          next_state = S1;
        else
          next_state = S0;
      end
      
      S2: begin
        if (data[1:0] == 2'b10)
          next_state = S3;
        else if (data[2:0] == 3'b010)
          next_state = S2;
        else
          next_state = S0;
      end
      
      S3: begin
        next_state = S0;
      end
    endcase
  end

endmodule