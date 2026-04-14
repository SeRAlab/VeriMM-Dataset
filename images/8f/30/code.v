module top_module(
    input [3:0] in,
    output reg [3:0] out
);integer i;
    
    always @(*) begin
        out = 4'b0; // initialize output to all zeros
        
        for (i = 0; i < 4; i = i + 1) begin
            out[i] = in[3-i]; // iterate over input bits in reverse order
        end
    end
    
endmodule