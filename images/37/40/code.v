module mux2to1 (  
    input [7:0] data0,  
    input [7:0] data1,  
    input sel,  
    output reg [7:0] y  
);  
    always @(*) begin  
        if (sel)  
            y = data1;  
        else  
            y = data0;  
    end  
endmodule