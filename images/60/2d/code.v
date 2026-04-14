module top_module(add, opa, opb, sum, co);input		add;
input	[26:0]	opa, opb;
output	[26:0]	sum;
output		co;



assign {co, sum} = add ? ({1'b0, opa} + {1'b0, opb}) : ({1'b0, opa} - {1'b0, opb});

endmodule