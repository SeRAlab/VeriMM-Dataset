module RsDecodeDpRam (
   q,
   clock,
   data,
   rdaddress,
   rden,
   wraddress,
   wren
   );
   output [8:0]   q;
   input          clock;
   input  [8:0]   data;
   input  [8:0]   rdaddress;
   input  [8:0]   wraddress;
   input          rden;
   input          wren;
   reg [8:0]   mem[0:351];
    always@(posedge clock) begin
       if (wren)
         mem[wraddress] <= data;
    end
    reg [8:0] rRdAddr;
    always@(posedge clock) begin
       rRdAddr <= rdaddress;
    end
    reg  rRdEn;
    always@(posedge clock) begin
       rRdEn <= rden;
    end
    reg [8:0] q;
    always@(posedge clock) begin
       if (rRdEn)
          q <= mem[rRdAddr];
    end
 endmodule