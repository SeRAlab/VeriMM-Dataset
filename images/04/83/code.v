module sr_latch(  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Qn  
);  
    always @(S, R) begin  
        case ({S, R})  
            2'b00: ; // retain previous state  
            2'b01: begin  
                Q = 0;  
                Qn = 1;  
            end  
            2'b10: begin  
                Q = 1;  
                Qn = 0;  
            end  
            2'b11: begin  
                // Indeterminate state, can retain previous state or handle as per requirements  
                // Here we will retain the previous state  
            end  
        endcase  
    end  
endmodule