module top_module(input CLK, input RST, input [31:0] lengthOutput, input [63:0] inp, input inp_valid, output [63:0] out, output out_valid);parameter WAIT_CYCLES = 2048;
   
   reg [31:0] outCnt;
   reg [31:0] outLen;

   reg        fixupMode;
   reg [31:0]  outClks = 0;
   
   
   always@(posedge CLK) begin
     if (RST) begin 
        outCnt <= 32'd0;
        outLen <= lengthOutput;
        fixupMode <= 1'b0;
        outClks <= 32'd0;
     end else begin
        outClks <= outClks + 32'd1;
        
        if(inp_valid || fixupMode) begin outCnt <= outCnt+32'd8; end 
        if(outClks > WAIT_CYCLES) begin fixupMode <= 1'b1; end
     end
   end

   assign out = (fixupMode)?(64'hDEAD):(inp);
   assign out_valid = (RST)?(1'b0):((fixupMode)?(outCnt<outLen):(inp_valid));
endmodule