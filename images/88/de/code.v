module top_module(input s,input r,output q,output p);wire wq,wp;
nand(wq,wp,s);
nand(wp,wq,r);
assign p=wp;
assign q=wq;
endmodule