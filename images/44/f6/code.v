module top_module(
    input [1023:0] in, // 1024-bit input vector
    input [7:0] sel, // 8-bit select input
    output [3:0] out // 4-bit output from the selected input
);// Barrel shifter
    wire [1023:0] shifted_in;
    assign shifted_in = (sel[7]) ? {in[1023:768], in[767:0]} :
                      (sel[6]) ? {in[767:512], in[511:0]} :
                      (sel[5]) ? {in[511:256], in[255:0]} :
                      (sel[4]) ? {in[255:0]} :
                      (sel[3]) ? {in[511:0]} :
                      (sel[2]) ? {in[255:0]} :
                      (sel[1]) ? {in[511:256]} :
                                 {in[767:0]};
    
    // Multiplexer
    wire [3:0] mux_output;
    assign mux_output = shifted_in[sel[2:0] * 4 +: 4]; // Select 4 bits based on sel

    assign out = mux_output;

endmodule