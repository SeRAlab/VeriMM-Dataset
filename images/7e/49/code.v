module top_module(clock, reset, start, N, dp, done, counter, sr);input         clock;
input	      start;         
input	      reset;         
input   [8:0] N;             

output  [8:0] dp;	     
output	      done;
output	[7:0] counter;
output  [7:0] sr;

reg     [8:0] dp;	   
reg	[7:0] sr;
reg	[7:0] counter;
reg	[1:0] startbuf;
reg	      done;
reg	[2:0] state;

parameter INIT 		= 3'b000;
parameter RUN 		= 3'b001;
parameter ALMOSTDONE 	= 3'b010;
parameter DONE 		= 3'b011;
parameter WAIT 		= 3'b100;


always @(posedge clock or posedge reset) begin

    if (reset == 1) begin

	dp <= 9'b0;
	sr <= 8'b0;
	counter <= 8'b0;
	startbuf <= 2'b00;
	done <= 0;
	state <= INIT;

    end else begin

	if (state == INIT) begin
	    counter <= 255 - N[8:1] + 3;
	    sr <= 8'b0;
	    done <= 0;
	    state <= RUN;

	end else if (state == RUN) begin
	    sr[7] <= sr[6];
	    sr[6] <= sr[5];
	    sr[5] <= sr[4];
	    sr[4] <= sr[3];
	    sr[3] <= sr[2];
	    sr[2] <= sr[1];
	    sr[1] <= sr[0];
	    sr[0] <= ~(sr[7] ^ sr[5] ^ sr[4] ^ sr[3]);
	    counter <= counter - 1;
	    if (counter == 0) begin
	       state <= ALMOSTDONE;
	    end

	end else if (state == ALMOSTDONE) begin
	    dp[0] <= N[0];
	    dp[8:1] <= sr[7:0];
	    state <= DONE;

	end else if (state == DONE) begin
	    done <= 1;
	    state <= WAIT;

	end else if (state == WAIT) begin
	    if (startbuf == 2'b01) begin
		state <= INIT;
	    end
	end

	startbuf <= {startbuf[0], start};
    end
end

endmodule