module top_module(clock, char, keyboard_data);input clock;
  input char;
  output reg [3:0] keyboard_data;

  reg [3:0] counter;
  reg flag;
  reg [7:0] temp_data;

  initial begin 
    keyboard_data <= 4'b0000;
    counter <= 4'b0001;
    flag <= 1'b0;
  end 

  always @(negedge clock) begin 
    case (counter) 
      1:;
      2: temp_data[0] <= char; 
      3: temp_data[1] <= char;
      4: temp_data[2] <= char;
      5: temp_data[3] <= char;
      6: temp_data[4] <= char;
      7: temp_data[5] <= char;
      8: temp_data[6] <= char;
      9: temp_data[7] <= char;
      10: flag <= 1'b1;
      11: flag <= 1'b0;
    endcase
    
    if (counter <= 10) begin 
     counter <= counter + 1;
    end 
    else if (counter == 11) begin 
      counter <= 4'b0001;
    end 
  end 

  always @(posedge flag) begin 
    /*
    * A = 1C, S = 1B, D = 23, F = 2B
    */
   if (temp_data == 8'h1C) begin  
     keyboard_data <= 4'b1000;
   end  
   else if (temp_data == 8'h1B) begin 
     keyboard_data <= 4'b0100;
   end 
   else if (temp_data == 8'h23) begin 
     keyboard_data <= 4'b0010;
   end 
   else if (temp_data == 8'h2B) begin 
     keyboard_data <= 4'b0001;
   end 
   else begin 
     keyboard_data <= 4'b0000;
   end 
  end 
endmodule