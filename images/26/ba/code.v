module sr_flip_flop (  
    input S,  
    input R,  
    input clk,  
    output reg Q  
);  

always @(posedge clk) begin  
    if (S && ~R)  
        Q <= 1;  
    else if (~S && R)  
        Q <= 0;  
    // If S and R are both 0, maintain the state (Q remains unchanged)  
    // If S and R are both 1, maintain the state (Q remains unchanged)  
end  
endmodule