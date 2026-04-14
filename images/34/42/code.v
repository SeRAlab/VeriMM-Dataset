module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire E,  
    output reg Q,  
    output wire Qn  
);  
    assign Qn = ~Q;  

    always @(posedge E) begin  
        if (S && R) begin  
            // Indeterminate state, do not change Q  
        end else if (S) begin  
            Q <= 1;  
        end else if (R) begin  
            Q <= 0;  
        end  
        // If both S and R are low, Q remains unchanged  
    end  
endmodule