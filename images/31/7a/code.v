module phase_detector (  
    input wire clk,  
    input wire A,  
    input wire B,  
    output reg A_leads_B,  
    output reg B_leads_A,  
    output reg aligned  
);  
    always @(posedge clk) begin  
        A_leads_B <= (A == 1 && B == 0);  
        B_leads_A <= (A == 0 && B == 1);  
        aligned <= (A == B);  
    end  
endmodule