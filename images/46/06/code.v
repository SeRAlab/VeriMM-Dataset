module top_module(input iCLK,input lap,output [7:0] giatri);reg [7:0] giatriluutru=8'h00;

always @(posedge iCLK )
if(lap==1'b0) begin
              giatriluutru=8'h00;
              end
else
             begin
            giatriluutru=giatriluutru+1;
             end  
assign giatri=giatriluutru;endmodule