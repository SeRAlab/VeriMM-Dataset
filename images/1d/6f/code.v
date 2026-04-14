module sr_latch (
    input wire S,
    input wire R,
    input wire E,
    output reg Q,
    output reg Qn
);  
    always @(*) begin  
        if (E) begin  
            if (S && ~R) begin  
                Q = 1;  
                Qn = 0;  
            end else if (~S && R) begin  
                Q = 0;  
                Qn = 1;  
            end  
            // If both S and R are 0, maintain previous state  
        end  
    end  
endmodule