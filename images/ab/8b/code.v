module top_module(clk, 
	p0, p1, pw, 
	lbid0, lbid1, lbidw, 
	ofs0, ofs1, ofsw, 
	we, pc_update_req);input clk, we;
	input [5:0] p0, p1, pw;
	output reg [11:0] lbid0, lbid1;
	input [11:0] lbidw;
	output reg [15:0] ofs0, ofs1;
	input [15:0] ofsw;
	output pc_update_req;

	reg [11:0] lbidfile[63:0];	
	reg [15:0] ofsfile[63:0];
	
	wire [5:0] rwp0;

	assign pc_update_req = (we == 1 && pw == 6'h3f) ? 1 : 0;
	
	
	assign rwp0 = (we == 1) ? pw : p0;
	
	always @ (posedge clk)
		begin
			if(we == 1) begin
				lbidfile[rwp0] <= lbidw;
				ofsfile[rwp0]  <= ofsw;
			end
			else begin
				lbid0 <= lbidfile[rwp0];
				ofs0  <= ofsfile[rwp0];
			end
		end
	
	always @ (posedge clk)
		begin
			lbid1 <= lbidfile[p1];
			ofs1  <= ofsfile[p1];
		end
endmodule