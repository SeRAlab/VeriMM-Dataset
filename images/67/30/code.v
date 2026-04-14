module top_module(
    input [3:0] in,
    output [2:0] out
);// Local signals
    wire [3:0] shifted_in;
    
    // Shift input one bit to the right and insert '0' at MSB
    assign shifted_in = {1'b0, in[3:1]};
    
    // Assign output to shifted input
    assign out = shifted_in[2:0];

endmodule