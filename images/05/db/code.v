module SR_flip_flop(  
    input S,  
    input R,  
    input CLK,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge CLK) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // Hold state if both S and R are low  
    end  
endmodule