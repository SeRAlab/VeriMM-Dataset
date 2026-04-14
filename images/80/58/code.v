module top_module( clock,
	  _1, _2, _3, _6, _7, 
	  _22, _23);input clock; 
	input _1, _2, _3, _6, _7;
	output _22, _23;
	reg __c17_s__1, __c17_s__2, __c17_s__3, __c17_s__6;
	wire new_n8_, new_n9_, new_n10_, new_n12_;
	wire new_w0, new_w1, new_w2, new_w3;
	assign new_n8_ = __c17_s__1  & __c17_s__3;
	assign new_n9_ = __c17_s__3 & __c17_s__6;
	assign new_n10_ = __c17_s__2 & ~new_n9_;
	assign _22 = new_n8_ | new_n10_;
	assign new_n12_ = _7 & ~new_n9_;
	assign _23 = new_n10_ | new_n12_;
	assign new_w0 = _1;
	assign new_w1 = _2;
	assign new_w2 = _3;
	assign new_w3 = _6;
	always @ (posedge clock) begin
		__c17_s__1 <= new_w0;
		__c17_s__2 <= new_w1;
		__c17_s__3 <= new_w2;
		__c17_s__6 <= new_w3;
	end
endmodule