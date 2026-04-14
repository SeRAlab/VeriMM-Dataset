module top_module(input [1:0] SHTOp,input [4:0] shift,input [31:0] a,output[31:0] out);wire [31:0] temp;
  wire [31:0] tem;
  assign tem=32'hfffffffe;

  
  assign temp=a>>shift;
  
  assign out=(SHTOp==2'b00)?32'h00000000:
             (SHTOp==2'b01)?a<<shift:
             (SHTOp==2'b10)?temp:
             (SHTOp==2'b11)?((a[31])?(temp|(tem<<~(shift))):temp)
             :32'h11111111;
endmodule