module top_module(
	
	dqs_in,
	lpf_out,
	se,
	si,
	strobe,
	
	dqs_out,
	so          );input		dqs_in;
	input [4:0]	lpf_out;
	input		se;
	input		si;
	input		strobe;

	output		dqs_out;
	output		so;

       parameter DELAY = 1250;

        reg             dqs_out;

        
        always @(dqs_in)
          begin
            dqs_out <= #DELAY dqs_in;
          end


endmodule