module top_module(input [1:0] din,
                     output reg [1:0] next_state,
                     output reg [1:0] next_s
                     );parameter    state1 = 2'b01,  state2=2'b10,  state3=2'b11;

   always @(din or state1 or state2 or state3)
   casex (din) 
     2'b1x: next_state = state1;
     2'bx0: next_state = state3;
   endcase 

   always @(din or state1 or state2 or state3)
   casex (din) 
     2'b1x: next_s = state1;
     2'b0x: next_s = state1;
   endcase 
endmodule