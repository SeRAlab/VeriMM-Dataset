module top_module(
    input wire SIGN_X0,
    input wire SIGN_Y0,
    input wire SIGN_Z0,
    output wire SIGN_X,
    output wire SIGN_Y,
    output wire SIGN_Z
    );assign SIGN_X = ~SIGN_Y0 ^ SIGN_X0; 
    assign SIGN_Y = ~SIGN_Y0 ^ SIGN_Y0; 
    assign SIGN_Z = ~SIGN_Y0 ^ SIGN_Z0; 
    
endmodule