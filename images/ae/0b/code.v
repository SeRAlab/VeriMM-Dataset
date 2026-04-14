module top_module(input clk, rst_n,
             input [31:0] dataW, Addr,
             input MemRW,               
             output [31:0] dataR);reg [7:0] DMEMi [0:256];


assign dataR=(MemRW==1'b0)? {DMEMi[Addr+3], DMEMi[Addr+2], DMEMi[Addr+1], DMEMi[Addr]}: 32'hxxxxxxxx;
always @(posedge clk) begin
  if (!rst_n) begin
    
    {DMEMi[Addr+3], DMEMi[Addr+2], DMEMi[Addr+1], DMEMi[Addr]} <= 32'hxxxxxxxx;
  end
  else begin
    if (MemRW==1'b1) begin
      {DMEMi[Addr+3], DMEMi[Addr+2], DMEMi[Addr+1], DMEMi[Addr]} <= dataW;
      
    end
    else begin
      {DMEMi[Addr+3], DMEMi[Addr+2], DMEMi[Addr+1], DMEMi[Addr]} <=  {DMEMi[Addr+3], DMEMi[Addr+2], DMEMi[Addr+1], DMEMi[Addr]};
      
    end
  end
end
endmodule