module top_module(
   clk, 
   rstp, 
   din, 
   writep, 
   readp, 
   dout, 
   emptyp, 
   fullp);input             clk;
input             rstp;
input [31:0]      din;
input             readp;
input             writep;
output [31:0]     dout;
output            emptyp;
output            fullp;



parameter         DEPTH = 1024;               
parameter         MAX_COUNT = 10'b1111111111;  

reg               emptyp;
reg               fullp;


reg [31:0]        dout;



reg [(DEPTH-1):0]        tail;
reg [(DEPTH-1):0]        head;




reg [(DEPTH-1):0]        count;



reg [31:0] fifomem[0:MAX_COUNT];



always @(posedge clk) begin
   if (rstp == 1) begin
      dout <= 16'h0000;
   end
   else begin
      dout <= fifomem[tail];
   end
end 
     

always @(posedge clk) begin
   if (rstp == 1'b0 && writep == 1'b1 && fullp == 1'b0) begin
      fifomem[head] <= din;
   end
end
                  


always @(posedge clk) begin
   if (rstp == 1'b1) begin
      head <= 2'b00;
   end
   else begin
      if (writep == 1'b1 && fullp == 1'b0) begin
         
         head <= head + 1;
      end
   end
end



always @(posedge clk) begin
   if (rstp == 1'b1) begin
      tail <= 2'b00;
   end
   else begin
      if (readp == 1'b1 && emptyp == 1'b0) begin
         
         tail <= tail + 1;
      end
   end
end



always @(posedge clk) begin
   if (rstp == 1'b1) begin
      count <= 2'b00;
   end
   else begin
      case ({readp, writep})
         2'b00: count <= count;
         2'b01: 
            
            if (count != MAX_COUNT) 
               count <= count + 1;
         2'b10: 
            
            if (count != 2'b00)
               count <= count - 1;
         2'b11:
            
            count <= count;
      endcase
   end
end

         




always @(count) begin
   if (count == 2'b00)
      emptyp <= 1'b1;
   else
      emptyp <= 1'b0;
end




always @(count) begin
   if (count == MAX_COUNT)
      fullp <= 1'b1;
   else
      fullp <= 1'b0;
end

endmodule