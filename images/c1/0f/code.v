module	compressor42(
input	A,
input	B,
input	C,
input	D,
input	cin,
output	S,
output	carry,
output	cout
);
wire	AB;
assign	AB=A&B;
wire	AxorB;
assign	AxorB=A^B;
wire	CD;
assign	CD=C&D;
wire	CxorD;
assign	CxorD=C^D;
wire	AxBxCxD=AxorB^CxorD;
assign	cout=AB|CD;
assign	carry=(AB&CD)|(AxorB&CxorD)|((AxBxCxD)&cin);
assign	S=AxBxCxD^cin;
endmodule