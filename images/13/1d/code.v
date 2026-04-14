module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire CLK,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (R)  
            Q <= 0;  
        else if (S)  
            Q <= 1;  
    end  
endmodule