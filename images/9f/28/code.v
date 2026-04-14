module top_module(
    input sign,
    input [3:0] enc_vec,
    input [3:0] a_vec,
    output pp_i);wire [3:0] a_sign;
    
    assign a_sign[3] = sign ^ a_vec[3];
    assign a_sign[2] = sign ^ a_vec[2];
    assign a_sign[1] = sign ^ a_vec[1];
    assign a_sign[0] = sign ^ a_vec[0];
    
    
    wire [3:0] a_enc;
    assign a_enc = a_sign & enc_vec;
    
    
    assign pp_i = (a_enc[3] | a_enc[2] | a_enc[1] | a_enc[0]);endmodule