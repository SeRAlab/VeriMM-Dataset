module top_module(c,q);// Output signals representing the 11-bit decoded vector
	output reg [10:0] q;
	
	// Input signals representing the 15-bit input
	input [14:0] c;
	
	// Declare "reg" signals...
	// Parity bits for Hamming decoding - P's (P primes)
	reg [3:0] pb;
	// Syndrome bits for Hamming decoding
	reg [3:0] s;
	// Temporary variable to contain the conversion from binary to decimal
	reg [3:0] temp;
	// Temporary storage for inputs
	reg [14:0] inputs;
	
	// Declare "wire" signals...
	// Defining constants: parameter [name_of_constant] = value;
	
	// Calculate parity prime bits
	always @(*)
	begin
		pb[0] = c[2]^c[4]^c[6]^c[8]^c[10]^c[12]^c[14];
		pb[1] = c[2]^c[5]^c[6]^c[9]^c[10]^c[13]^c[14];
		pb[2] = c[4]^c[5]^c[6]^c[11]^c[12]^c[13]^c[14];
		pb[3] = c[8]^c[9]^c[10]^c[11]^c[12]^c[13]^c[14];
	end
	
	// Calculate syndrome bits
	always @(*)
	begin
		s[0] = c[0]^pb[0];
		s[1] = c[1]^pb[1];
		s[2] = c[3]^pb[2];
		s[3] = c[7]^pb[3];
	end
	
	// Correct detected error bit
	always @(*)
	begin
		temp = s[0]*1 + s[1]*2 + s[2]*4 + s[3]*8 - 1;
		inputs = c;
		inputs[temp] = c[temp]^1;
	end
	
	// Assign decoded signal bits to syndrome bits
	always @(*)
	begin
		q[0] = inputs[2];
		q[1] = inputs[4];
		q[2] = inputs[5];
		q[3] = inputs[6];
		q[4] = inputs[8];
		q[5] = inputs[9];
		q[6] = inputs[10];
		q[7] = inputs[11];
		q[8] = inputs[12];
		q[9] = inputs[13];
		q[10] = inputs[14];
	end
	
endmodule