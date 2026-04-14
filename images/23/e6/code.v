module timer_32bit (  
    input clk,  
    input rst_n,  
    input load_en,  
    input [31:0] load_value,  
    output reg [31:0] count  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            count <= 32'b0;  
        else if (load_en)  
            count <= load_value;  
        else  
            count <= count + 1;  
    end  
endmodule