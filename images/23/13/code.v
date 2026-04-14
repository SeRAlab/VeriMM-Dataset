module binary_counter (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    output reg [1:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 2'b00;  
        else if (enable)  
            count <= (count == 2'b11) ? 2'b00 : count + 1;  
    end  
endmodule