module top_module(
    input [3:0] in,
    output reg [4:0] out
);always @(*) begin
        if (in[3] == 1) begin // if input is negative
            out[4] = 1; // set sign bit to 1
            out[3:0] = ~in[3:0] + 1; // take two's complement of magnitude
        end else begin // if input is positive
            out[4] = 0; // set sign bit to 0
            out[3:0] = in[3:0]; // copy magnitude
        end
    end
    
endmodule