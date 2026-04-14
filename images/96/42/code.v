module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg match
);reg [1:0] state, next_state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00; // initialize to S0
      match <= 1'b0;
    end
    else begin
      state <= next_state;
      if (state == 2'b11) // if in S3, pattern has been detected
        match <= 1'b1;
      else
        match <= 1'b0;
    end
  end
  
  always @(*) begin
    case (state)
      2'b00: if (data == 4'b0001) next_state = 2'b01; else next_state = 2'b00;
      2'b01: if (data == 4'b0010) next_state = 2'b10; else next_state = 2'b01;
      2'b10: if (data == 4'b0100) next_state = 2'b00; else next_state = 2'b11;
      2'b11: if (data == 4'b1000) next_state = 2'b01; else next_state = 2'b00;
    endcase
  end
  
endmodule