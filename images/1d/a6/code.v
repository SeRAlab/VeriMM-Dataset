module sample_rate_converter(  
    input clk,  
    input rst,  
    input din,  
    output reg dout  
);  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dout <= 0;  
            count <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 2) begin  
                dout <= din;  
                count <= 0;  
            end  
        end  
    end  
endmodule