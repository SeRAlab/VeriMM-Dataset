module shift_register_8bit(clk, reset, load, serial_in, parallel_in, Q);
     input clk;
     input reset;
     input load;
     input serial_in;
     input [7:0] parallel_in;
     output reg [7:0] Q;

     always @(posedge clk) begin
          if (reset)
               Q <= 8'b00000000;
          else if (load)
               Q <= parallel_in;
          else
               Q <= {serial_in, Q[7:1]};
     end
endmodule