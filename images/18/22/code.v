module bubble_sort(input [7:0] a,  
                   input [7:0] b,  
                   input [7:0] c,  
                   input [7:0] d,  
                   input [7:0] e,  
                   output reg [7:0] out1,  
                   output reg [7:0] out2,  
                   output reg [7:0] out3,  
                   output reg [7:0] out4,  
                   output reg [7:0] out5);  

    reg [7:0] arr [0:4];  
    integer i, j;  

    always @(*) begin  
        arr[0] = a;  
        arr[1] = b;  
        arr[2] = c;  
        arr[3] = d;  
        arr[4] = e;  

        for (i = 0; i < 4; i = i + 1) begin  
            for (j = 0; j < 4 - i; j = j + 1) begin  
                if (arr[j] > arr[j + 1]) begin  
                    {arr[j], arr[j + 1]} = {arr[j + 1], arr[j]};  
                end  
            end  
        end  

        out1 = arr[0];  
        out2 = arr[1];  
        out3 = arr[2];  
        out4 = arr[3];  
        out5 = arr[4];  
    end  
endmodule