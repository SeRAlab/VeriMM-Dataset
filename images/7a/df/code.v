module top_module(
	// inputs in alphabetical order
	dqs_in,
	lpf_out,
	se,
	si,
	strobe,
	//outputs in alphabetical order
	dqs_out,
	so          );input		dqs_in;
	input [4:0]	lpf_out;
	input		se;
	input		si;
	input		strobe;

	output		dqs_out;
	output reg	so;  // Change output declaration to reg

       parameter DELAY = 1250;

        reg             dqs_out;
        reg             q1;
        reg             q2;
        reg             q3;
        reg             q4;

        // 1/4 cycle delay line.
        always @(dqs_in)
          begin
            q1 <= #DELAY dqs_in;
            q2 <= #DELAY q1;
            q3 <= #DELAY q2;
            q4 <= #DELAY q3;
            dqs_out <= #DELAY q4;
          end

        // strobe output
        always @(posedge strobe)
          begin
            if (se == 1)
              so <= si;  // This is now valid as so is declared as reg
          end

endmodule