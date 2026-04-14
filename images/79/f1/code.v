module top_module(
   // Outputs
   output reg [ARW-1:0] grant,
   output reg [ARW-1:0] arb_wait,
   // Inputs
   input clk,
   input clk_en,
   input reset,
   input hold,
   input [ARW-1:0] request
);parameter ARW=99;

   //wires
   wire [ARW-1:0] grant_mask;
   wire [ARW-1:0] request_mask;
   
   //regs
   reg [ARW-1:0]  grant_hold;

   //hold circuit
   always @ (posedge clk or posedge reset)
     if(reset)
       grant_hold[ARW-1:0] <= {(ARW){1'b0}};
     else if(clk_en)       
       grant_hold[ARW-1:0] <= grant[ARW-1:0] & {(ARW){hold}};

   //request blocking based on held previous requests
   genvar i;
   generate              
      for(i=0;i<ARW-1;i=i+1) begin : gen_block
         assign request_mask[i]=request[i] & ~(|grant_hold[ARW-1:i+1]);	 
      end
      assign request_mask[ARW-1]=request[ARW-1];//awlays on, loses on priority 
   endgenerate
   
   genvar j;
   assign grant_mask[0]   = 1'b0;   
   generate for (j=ARW-1; j>=1; j=j-1) begin : gen_arbiter     
      assign grant_mask[j] = |request_mask[j-1:0];
   end
   endgenerate
        
   //grant circuit
   assign grant[ARW-1:0] = request_mask[ARW-1:0] & ~grant_mask[ARW-1:0];

   //wait circuit  
   assign arb_wait[ARW-1:0] = request[ARW-1:0] & ({(ARW){hold}} | ~grant[ARW-1:0]);


   //makes sure we hold request one cycle after wait is gone!!!
   // synthesis translate_off
   always @*
     if((|(grant_hold[ARW-1:0] & ~request[ARW-1:0])) & ~reset  & $time> 0)
       begin
	  $display("ERROR>>Request not held steady in cell %m at time %0d", $time);
       end
   // synthesis translate_on
   
endmodule