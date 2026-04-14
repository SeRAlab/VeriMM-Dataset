module top_module(
    output reg [15:0] final_output,
    output reg carry_output,
    input [15:0]input1, input2
    );reg carry_in;		
	
task CRAFA_module(
    output reg sum,carry,
    input in1,in2,carry_in
    );

reg intermediate, gen, propagate;
begin
propagate = in1 ^ in2;
sum = propagate ^ carry_in;
gen = in1 & in2;
intermediate = propagate & carry_in;
carry = intermediate | gen;
end
endtask

task CRA4bit(
    output reg [3:0] cra_sum,
    output reg cra_carry_out,
    input [3:0] in1,in2,
    input carry_in
    );
reg carry1,carry2,carry3;
begin
CRAFA_module 	(cra_sum[0],carry1,in1[0],in2[0],carry_in);
CRAFA_module	(cra_sum[1],carry2,in1[1],in2[1],carry1);
CRAFA_module	(cra_sum[2],carry3,in1[2],in2[2],carry2);
CRAFA_module	(cra_sum[3],cra_carry_out,in1[3],in2[3],carry3);
end
endtask
	 	 
task CRA16bit(
    output reg [15:0] cra_sum,
    output reg cra_carry_out,
    input [15:0] in1,in2,
    input carry_in
    );
reg carry1,carry2,carry3;
begin
CRA4bit	(cra_sum[3:0],carry1,in1[3:0],in2[3:0],carry_in);
CRA4bit	(cra_sum[7:4],carry2,in1[7:4],in2[7:4],carry1);
CRA4bit	(cra_sum[11:8],carry3,in1[11:8],in2[11:8],carry2);
CRA4bit	(cra_sum[15:12],cra_carry_out,in1[15:12],in2[15:12],carry3);
end
endtask

always@*
begin
	carry_in = 1'b0;
	CRA16bit(final_output, carry_output, input1, input2, carry_in);

end	
endmodule