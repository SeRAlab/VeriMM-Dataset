module top_module(input  wire        clk,
   input  wire        rst,
   output reg  req,
   input  wire        res);reg [31:0] counter;
   reg [31:0] dataExpect;
   reg        dataValid;

   always @(posedge clk)
     if (rst) begin
        counter <= 0;
        req     <= 0;
        dataValid <= 0;
        dataExpect <= 0;
     end else begin
        dataValid <= req & ~res;
        if (dataValid) begin
           if (dataExpect != res)
             $display("%6d Main got %x !!! BAD!", $time, res);
           // else
           //  $display("%6d Main got %x as expected", $time, res);
        end

        if (~res) begin
           req   <= 1;
           req   <= counter;
           dataExpect <= req;
           counter <= counter + 1;

           //$display("%6d Main requests %x", $time, counter);
        end
     end
endmodule