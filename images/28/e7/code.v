module pulse_generator(  
    input clk,  
    input reset,  
    input start,  
    output reg pulse  
);  
    reg [2:0] count; // 3-bit counter for up to 7 cycles  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pulse <= 0;  
            count <= 0;  
        end  
        else if (start) begin  
            if (count < 5) begin  
                pulse <= 1;  
                count <= count + 1;  
            end  
            else begin  
                pulse <= 0;  
                count <= 0;  
            end  
        end  
        else begin  
            pulse <= 0;  
            count <= 0;  
        end  
    end  
endmodule