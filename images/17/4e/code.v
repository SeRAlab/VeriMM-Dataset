module sr_flip_flop (  
    input wire S,  
    input wire R,  
    input wire CLK,  
    input wire Reset,  
    output reg Q  
);  
always @(posedge CLK or posedge Reset) begin  
    if (Reset) begin  
        Q <= 0;  
    end else begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        // If S = 1 and R = 1, Q remains unchanged  
    end  
end  
endmodule