module top_module(extend, extended);input [15:0] extend;
output [31:0] extended;

assign extended = {16'b0, extend};

endmodule