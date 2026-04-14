module phase_detector (  
    input wire clk,  
    input wire ref,  
    input wire sig,  
    output reg out  
);  
    reg ref_d, sig_d;  

    always @(posedge clk) begin  
        ref_d <= ref;  
        sig_d <= sig;  
        if (ref_d && !sig_d)  
            out <= 1; // ref leads sig  
        else if (!ref_d && sig_d)  
            out <= 0; // sig leads ref  
        else  
            out <= out; // no change  
    end  
endmodule