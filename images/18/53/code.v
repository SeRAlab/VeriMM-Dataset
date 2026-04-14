module mux_2to1 (  
    input [4:0] a,  
    input [4:0] b,  
    input sel,  
    output reg [4:0] y  
);  
    reg [4:0] last_value;  

    always @(*) begin  
        if (sel) begin  
            y = b;  
            last_value = b;  
        end else begin  
            y = a;  
            last_value = a;  
        end  
    end  
endmodule