module Counter32Bit(  
    input clk,  
    input reset,  
    input load,  
    input [31:0] load_value,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 32'b0;  
        else if (load)  
            count <= load_value;  
        else  
            count <= count + 1;  
    end  
endmodule