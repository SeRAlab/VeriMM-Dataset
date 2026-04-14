module simple_DES(
    input [63:0] plaintext,
    input [55:0] key,
    input clk,
    input rst,
    output reg [63:0] ciphertext
);
    // Initial Permutation (IP)
    function [63:0] initial_permutation;
        input [63:0] data;
        begin
            initial_permutation = {data[58], data[50], data[42], data[34], data[26], data[18], data[10], data[2], 
                                   data[60], data[52], data[44], data[36], data[28], data[20], data[12], data[4],
                                   data[62], data[54], data[46], data[38], data[30], data[22], data[14], data[6],
                                   data[57], data[49], data[41], data[33], data[25], data[17], data[9], data[1],
                                   data[59], data[51], data[43], data[35], data[27], data[19], data[11], data[3]};
        end
    endfunction

    // Final Permutation (FP)
    function [63:0] final_permutation;
        input [63:0] data;
        begin
            final_permutation = {data[40], data[8], data[48], data[16], data[56], data[24], data[64], data[32],
                                 data[39], data[7], data[47], data[15], data[55], data[23], data[63], data[31],
                                 data[38], data[6], data[46], data[14], data[54], data[22], data[62], data[30],
                                 data[37], data[5], data[45], data[13], data[53], data[21], data[61], data[29],
                                 data[36], data[4], data[44], data[12], data[52], data[20], data[60], data[28]};
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 64'b0;
        end else begin
            ciphertext <= final_permutation(initial_permutation(plaintext)); // Simplified DES
        end
    end
endmodule