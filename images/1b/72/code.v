module quick_sort_partition(  
    input [7:0] num0,  
    input [7:0] num1,  
    input [7:0] num2,  
    input [7:0] num3,  
    input [7:0] pivot,  
    output reg [7:0] less0,  
    output reg [7:0] less1,  
    output reg [7:0] greater0,  
    output reg [7:0] greater1  
);  
    always @(*) begin  
        // Initialize outputs  
        less0 = 8'b0;  
        less1 = 8'b0;  
        greater0 = 8'b0;  
        greater1 = 8'b0;  
        
        // Partition logic  
        if (num0 < pivot) less0 = num0;  
        else greater0 = num0;  
        
        if (num1 < pivot) less1 = num1;  
        else greater1 = num1;  
        
        if (num2 < pivot) less0 = num2;  
        else greater0 = num2;  
        
        if (num3 < pivot) less1 = num3;  
        else greater1 = num3;  
    end  
endmodule