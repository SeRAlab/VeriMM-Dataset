module echo_cancellation(input clk, input rst, input [15:0] audio_in, input [15:0] echo_in, output reg [15:0] audio_out);  
  reg [15:0] buffer [0:4];  
  integer i;  

  always @(posedge clk or posedge rst) begin  
    if (rst) begin  
      audio_out <= 16'b0;  
      for (i = 0; i < 5; i = i + 1)  
        buffer[i] <= 16'b0;  
    end else begin  
      audio_out <= audio_in - echo_in;  
      for (i = 4; i > 0; i = i - 1)  
        buffer[i] <= buffer[i-1];  
      buffer[0] <= audio_in;  
    end  
  end  
endmodule