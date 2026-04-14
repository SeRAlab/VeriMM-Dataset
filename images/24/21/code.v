module data_selector(  
    input [15:0] A,  
    input [15:0] B,  
    input sel,  
    output reg [15:0] Y  
);  
    always @(*) begin  
        if (sel == 0)  
            Y = A;  
        else  
            Y = B;  
    end  
endmodule