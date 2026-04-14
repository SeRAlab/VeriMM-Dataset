module mux_forwarding(  
    input [4:0] a,  
    input [4:0] b,  
    input sel,  
    input forward_en,  
    output reg [4:0] y  
);  
    always @(*) begin  
        if (forward_en)  
            y = a;  
        else  
            y = sel ? b : a;  
    end  
endmodule