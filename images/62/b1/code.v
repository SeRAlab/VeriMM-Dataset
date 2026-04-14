module top_module(clk, rst, op, in1, in2, out, cout);// input
	input         clk;
	input         rst;
	input  [1:0]  op;
	input  [7:0]  in1;
	input  [7:0]  in2;

// output
	output [7:0]  out;
	output        cout;

// local
	reg    [8:0]  sum;

// comb
	// implement the combinational logic for the calculator
	assign out = sum[7:0];
	assign cout = sum[8];

// proc
	always @(posedge clk)
	begin
		if (rst)
		begin
			// set the output and carry-out to 0
			sum <= 0;
		end
		else
		begin
			// implement the sequential logic for the calculator
			case (op)
				2'b00: sum <= {1'b0, in1} + {1'b0, in2}; // addition
				2'b01: sum <= {1'b0, in1} - {1'b0, in2}; // subtraction
			endcase
		end
	end

endmodule