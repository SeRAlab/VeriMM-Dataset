module top_module(clk,resetn,d,en,q);input clk;          // clock input
input resetn;       // reset input
input en;           // enable input
input [31:0] d;     // data input
output [31:0] q;    // output

reg [31:0] q;       // register to store output

always @(posedge clk) begin
    if (resetn == 0) begin
        q <= 0;        // clear output if reset is low
    end
    else if (en == 1) begin
        q <= d;        // update output if enable is high
    end
end

endmodule