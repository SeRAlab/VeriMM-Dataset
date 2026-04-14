module top_module(/*AUTOARG*/
                      // Outputs
                      var1,
                      lo_mux,
                      // Inputs
                      state,
                      add,
                      lo,
                      mc_32pff,
                      mc_losel,
                      slo
                      );input [2:1] state;
   input [39:0] add;
   input [63:0] lo;
   input mc_32pff, slo;
   input [5:0] mc_losel;
   output reg var1;  // Changed to reg as we need to drive it in always blocks.
   output reg [63:8] lo_mux;  // Changed to reg as lo_mux is assigned in an always block.
   
   parameter
     IDLE  = 1,
     CAS1  = 2;
   
   always @(state) begin
      case (state)
        IDLE: begin
           var1  = 1'b1;
        end
        CAS1: begin
           var1  = 1'b1;
        end
        default: begin
           var1  = 1'b1;
        end
      endcase
   end
   
   always @(add or lo or mc_32pff or mc_losel or slo or var1) begin
      case(mc_losel)
        6'b000001:  lo_mux  = mc_32pff ? {add[39:0],lo[31:8]} :
                              {add[7:0],lo[63:8]};
        
        6'b010000:  lo_mux  = lo;
        6'b100000:  lo_mux  = var1 ? IDLE : slo;
        default:    lo_mux  = 0;  // Adding a default case to avoid latches.
      endcase
   end // always @ (...
   
endmodule