module lfsr_12bit (
    input clk,
    input reset,
    output reg [11:0] q);

wire feedback = q[11] ^ q[3] ^ q[2] ^ q[0]; // Example polynomial

always @(posedge clk) begin
    if (reset)
        q <= 12'b000000000001;
    else
        q <= {q[10:0], feedback};
    end
    
endmodule