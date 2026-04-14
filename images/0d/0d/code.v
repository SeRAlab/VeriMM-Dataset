module phase_detector (  
    input clk,  
    input A,  
    input B,  
    output reg out_lead,  
    output reg out_lag,  
    output reg out_inphase  
);  
    reg [1:0] state;  

    always @(posedge clk) begin  
        if (A == B) begin  
            out_inphase <= 1;  
            out_lead <= 0;  
            out_lag <= 0;  
        end else if (A && !B) begin  
            out_lead <= 1;  
            out_lag <= 0;  
            out_inphase <= 0;  
        end else if (!A && B) begin  
            out_lag <= 1;  
            out_lead <= 0;  
            out_inphase <= 0;  
        end  
    end  
endmodule