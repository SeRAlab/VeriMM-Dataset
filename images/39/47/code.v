module T_latch (  
    input wire T,  
    input wire E,  
    output reg Q  
);  
always @(posedge T or negedge E) begin  
    if (!E)  
        Q <= Q;  
    else  
        Q <= ~Q;  
end  
endmodule