module ecc_point_addition(input clk, input rst,  
                           input [7:0] x1, input [7:0] y1,  
                           input [7:0] x2, input [7:0] y2,  
                           output reg [7:0] x3, output reg [7:0] y3);  

  reg [15:0] m; // Slope  
  reg [15:0] x3_temp, y3_temp;  

  always @(posedge clk or posedge rst) begin  
    if (rst) begin  
      x3 <= 8'b0;  
      y3 <= 8'b0;  
    end else begin  
      if (x1 == x2 && y1 == y2) begin // Point doubling case  
        m <= (3 * x1 * x1 + 1) / (2 * y1); // Derivative of the curve  
      end else begin  
        m <= (y2 - y1) / (x2 - x1); // Slope for point addition  
      end  
      
      x3_temp <= m * m - x1 - x2;  
      y3_temp <= m * (x1 - x3_temp) - y1;  
      
      x3 <= x3_temp[7:0];  
      y3 <= y3_temp[7:0];  
    end  
  end  
endmodule