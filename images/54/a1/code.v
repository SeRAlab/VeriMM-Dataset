module top_module(din, rst, en, clk, q, se, si, so);// synopsys template

parameter SIZE = 1;

input [SIZE-1:0] din;  // data in
input en;              // functional enable
input rst;             // reset
input clk;             // clk or scan clk

output [SIZE-1:0] q;   // output

input se;              // scan-enable
input [SIZE-1:0] si;   // scan-input
output [SIZE-1:0] so;  // scan-output

reg [SIZE-1:0] q;

// Enable Interpretation. Ultimate interpretation depends on design
// 
// rst en se out
//------------------
// 1  x  x  0   ; reset dominates
// 0  x  1  sin ; scan dominates
// 0  1  0  din
// 0  0  0  q
//

`ifdef NO_SCAN
always @ (posedge clk)
    q[SIZE-1:0] <= (rst ? {SIZE{1'b0}} : ((en) ? din[SIZE-1:0] : q[SIZE-1:0]));
`else

always @ (posedge clk)

//  q[SIZE-1:0] <= rst ? {SIZE{1'b0}} : ((se) ? si[SIZE-1:0] : ((en) ? din[SIZE-1:0] : q[SIZE-1:0]));
    q[SIZE-1:0] <= se ? si[SIZE-1:0] : (rst ? {SIZE{1'b0}} : ((en) ? din[SIZE-1:0] : q[SIZE-1:0]));

assign so[SIZE-1:0] = q[SIZE-1:0];

`endif

endmodule