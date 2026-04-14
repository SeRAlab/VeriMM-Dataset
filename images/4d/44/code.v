module top_module(input [3:0] X,Y,input Cin,output [3:0] Sum,output C_out
    );reg [1:0] c00sum00,c01sum01,c10sum10,c11sum11,c20sum20,c21sum21,c30sum30,c31sum31;

wire [1:0]mux_out01,mux_out02,mux_out03,mux_out04;
wire [2:0]mux_out11,mux_out12;
assign Sum = Cin? {mux_out12[1:0],mux_out02[0],c01sum01[0]}:{mux_out11[1:0],mux_out01[0],c00sum00[0]};
assign C_out = Cin?mux_out12[2]:mux_out11[2]; 
assign mux_out01=c00sum00[1]?c11sum11:c10sum10,
       mux_out02=c01sum01[1]?c11sum11:c10sum10,
		 mux_out03=c20sum20[1]?c31sum31:c30sum30,
		 mux_out04=c21sum21[1]?c31sum31:c30sum30;

assign mux_out11=mux_out01[1]?{mux_out04,c21sum21[0]}:{mux_out03,c20sum20[0]},
       mux_out12=mux_out02[1]?{mux_out04,c21sum21[0]}:{mux_out03,c20sum20[0]};
always @* begin	 
cond_cell(X[0],Y[0],c00sum00,c01sum01);
cond_cell(X[1],Y[1],c10sum10,c11sum11);
cond_cell(X[2],Y[2],c20sum20,c21sum21);
cond_cell(X[3],Y[3],c30sum30,c31sum31);	 
end	 
	 
task cond_cell(input x,y, output [1:0] c0sum0,c1sum1);
reg xr;
begin 
       xr = x^y;
       c0sum0 ={x&y,xr};
       c1sum1 ={x|y,~xr}; 
		 end
endtask

endmodule