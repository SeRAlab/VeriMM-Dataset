module top_module(
   input wire        clk,
   input wire [11:0] digits,
   output reg [7:0]  seven_seg,
   output reg [2:0]  seven_seg_en
   );reg [17:0] counter = 0;
   wire       seg_clk = counter[17];
   always @ (posedge clk) begin
      counter <= counter + 1;
   end

   
   reg [1:0] cur_digit = 0;

   always @ (posedge seg_clk) begin
      
      if (cur_digit == 2) begin
         cur_digit <= 0;
      end else begin
         cur_digit <= cur_digit + 1;
      end
      
      if (cur_digit == 2) begin
         seven_seg_en <= 3'b011;
         display_digit(digits[11:8]);
      end else if (cur_digit == 1) begin
         seven_seg_en <= 3'b101;
         display_digit(digits[7:4]);
      end else begin
         seven_seg_en <= 3'b110;
         display_digit(digits[3:0]);
      end
   end

   
   task display_digit;
      input [3:0] d;
      begin
         case (d)
           0: seven_seg <= 8'b00000011;
           1: seven_seg <= 8'b10011111;
           2: seven_seg <= 8'b00100101;
           3: seven_seg <= 8'b00001101;
           4: seven_seg <= 8'b10011001;
           5: seven_seg <= 8'b01001001;
           6: seven_seg <= 8'b01000001;
           7: seven_seg <= 8'b00011111;
           8: seven_seg <= 8'b00000001;
           9: seven_seg <= 8'b00001001;
           10: seven_seg <= 8'b00010001; 
           11: seven_seg <= 8'b11000001; 
           12: seven_seg <= 8'b01100011; 
           13: seven_seg <= 8'b10000101; 
           14: seven_seg <= 8'b01100001; 
           15: seven_seg <= 8'b01110001; 
         endcase
      end
   endtask

endmodule