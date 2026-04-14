module T_latch (  
    input wire T,  
    input wire E,  
    output reg Q  
);  
always @(posedge E) begin  
    if (T)  
        Q <= ~Q;  
end  
endmodule