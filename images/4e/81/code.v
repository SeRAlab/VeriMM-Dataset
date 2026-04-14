module top_module();reg [15:0] my_array[0:9];
   integer i;
   integer sum = 0;

   initial begin
      // Initialize array with the first 10 positive even numbers
      for (i = 0; i < 10; i = i + 1) begin
         my_array[i] = (i + 1) * 2;
      end

      // Update the value of the 5th element, remove out of bounds access
      my_array[4] = 0; // you can set it to any valid value instead of my_array[10]

      // Calculate the sum of all the elements in the array
      for (i = 0; i < 10; i = i + 1) begin
         sum = sum + my_array[i];
      end

      // Output the sum of all the elements in the array
      $display("The sum of all the elements in the array is %d", sum);
   end

endmodule