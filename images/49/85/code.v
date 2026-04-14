module top_module(
	input  clock,
	output [7:0]key_code,
	input  k_tr
);reg [15:0]tmp;
	wire[15:0]tmpa;
	reg tr;
	reg [15:0]step;
	wire[15:0]step_r;
	reg [15:0]TT;
	reg[5:0]st;
	reg go_end;


	always @(negedge k_tr or posedge clock) begin
	if (!k_tr) begin
   		step=0;
   		st=0;
   		tr=0;
	end
	else
	if (step<step_r) begin
  		case (st)
  		0: st=st+1;
  		1: begin tr=0; st=st+1;end
  		2: begin tr=1;st=st+1;end
  		3: if(go_end) st=st+1;
  		4: begin st=0;step=step+1;end
  		endcase
	end
	end


	wire [7:0]key_code1=(
		(TT[3:0]==1)?8'h2b:(
		(TT[3:0]==2)?8'h34:(
		(TT[3:0]==3)?8'h33:(
		(TT[3:0]==4)?8'h3b:(
		(TT[3:0]==5)?8'h42:(
		(TT[3:0]==6)?8'h4b:(
		(TT[3:0]==7)?8'h4c:(
		(TT[3:0]==10)?8'h52:(
		(TT[3:0]==15)?8'hf0:8'hf0
		))))))))
	);


	assign tmpa[15:0]=(
		(TT[7:4]==15)?16'h10:(
		(TT[7:4]==8)? 16'h20:(
		(TT[7:4]==9)? 16'h30:(
		(TT[7:4]==1)? 16'h40:(
		(TT[7:4]==3)? 16'h60:(
		(TT[7:4]==2)? 16'h80:(
		(TT[7:4]==4)? 16'h100:0
		))))))
	);


	always @(step) begin
	case (step)
		0:TT=8'hfa;
		1:TT=8'h1f;
	endcase
	end
	assign step_r=1;


	always @(negedge tr or posedge clock)begin
		if(!tr) begin tmp=0;go_end=0 ;end
		else if (tmp>tmpa)go_end=1; 
		else tmp=tmp+1;
	end
	assign key_code=(tmp<(tmpa-1))?key_code1:8'hf0;

endmodule