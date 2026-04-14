module noise_suppression (  
    input [4:0] signal_in,  
    output reg [4:0] signal_out  
);  
    integer noise_count;  
    integer i, majority;  
    reg [4:0] count;  

    always @(*) begin  
        count = 0;  
        majority = 0;  
        for (i = 0; i < 5; i = i + 1) begin  
            if (signal_in[i] == 1)  
                count = count + 1;  
        end  
        if (count > 2)  
            majority = 1;  
        else  
            majority = 0;  

        noise_count = 0;  
        for (i = 0; i < 5; i = i + 1) begin  
            if (signal_in[i] != majority)  
                noise_count = noise_count + 1;  
        end  

        if (noise_count > 2)  
            signal_out = {5{majority}};  
        else  
            signal_out = signal_in;  
    end  
endmodule