module top_module(
		  input wire 	     clk,
		  input wire 	     resetn,

		  
		  output wire 	     mem_valid,
		  input wire 	     mem_ready,
		  output wire 	     mem_instr,

		  output wire [31:0] mem_addr,
		  output wire [3:0]  mem_wstrb,
		  output wire [31:0] mem_wdata,
		  input wire [31:0]  mem_rdata,

		  input wire 	     tick
		  );wire [7:0] 			     msg [0:15];
   assign msg[0]  = "H";
   assign msg[1]  = "e";
   assign msg[2]  = "l";
   assign msg[3]  = "l";
   assign msg[4]  = "o";
   assign msg[5]  = " ";
   assign msg[6]  = "W";
   assign msg[7]  = "o";
   assign msg[8]  = "r";
   assign msg[9]  = "l";
   assign msg[10] = "d";
   assign msg[11] = "!";
   assign msg[12] = 8'h0a;
   assign msg[13] = 8'h0d;
   assign msg[14] = 8'h00;
   assign msg[15] = 8'h00;
   
   reg [3:0] 			     index;
   
   
   always @(posedge clk) begin
      if (!resetn) begin
         index <= 0;
      end else begin
         if (tick) begin
            index <= index + 4'd1;
         end
      end
   end
   
   
   assign mem_valid = tick;
   assign mem_instr = 1'b0;
   
   assign mem_addr =  tick ? 32'hffff0040 : 32'b0;
   assign mem_wstrb = tick ? 4'b1 : 4'b0;
   assign mem_wdata = tick ? msg[index] : 32'b0;

endmodule