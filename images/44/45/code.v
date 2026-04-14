module top_module(din, clk, q, se, si, so);// synopsys template

parameter SIZE = 1;

input [SIZE-1:0] din;     // data in
input clk;                // clk or scan clk

output reg [SIZE-1:0] q;  // changed to reg since it is assigned in an always block

input se;                 // scan-enable
input [SIZE-1:0] si;      // scan-input
output [SIZE-1:0] so;     // scan-output

reg [SIZE-1:0] scan_q;

always @ (posedge clk) begin
    if (se) begin
        scan_q <= si;
        q <= scan_q; // Update q to follow scan_q when se is high
    end else begin
        q <= din;    // Load data in when se is low
        scan_q <= din; // Ensure scan_q is updated when se is low
    end
end

assign so = scan_q; // Directly assign scan_q to so

endmodule