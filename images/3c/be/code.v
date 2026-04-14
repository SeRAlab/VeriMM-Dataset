module DES_round (
    input wire [7:0] data_in,
    input wire [7:0] key,
    output wire [7:0] data_out
);
    // Initial Permutation (IP)
    wire [7:0] ip;
    assign ip = {data_in[1], data_in[5], data_in[2], data_in[0], data_in[3], data_in[7], data_in[4], data_in[6]}; // a simple IP

    // Round Function
    wire [7:0] round_output;
    assign round_output = ip ^ key; // simple XOR round function

    // Final Permutation (FP)
    assign data_out = {round_output[3], round_output[0], round_output[2], round_output[6], 
                       round_output[4], round_output[7], round_output[5], round_output[1]}; // a simple FP
endmodule