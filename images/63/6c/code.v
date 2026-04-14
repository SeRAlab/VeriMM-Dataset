module top_module(input         clk,
                    
                    input [BITWIDTH-1:0]      readaddr1,
                    output reg [BITWIDTH-1:0] readout1,
                    input [BITWIDTH-1:0]      writeaddr1,
                    input [BITWIDTH-1:0]      writein1,
                    input                     we
                    );parameter SIZE = 32;
   parameter BITWIDTH = 32;
   
   
   reg [BITWIDTH-1:0] mem [0:SIZE-1];
 
   
   always @(posedge clk)
     begin
        if (we) begin
           mem[writeaddr1] = writein1;
        end
        readout1 <= mem[readaddr1];
     end

endmodule