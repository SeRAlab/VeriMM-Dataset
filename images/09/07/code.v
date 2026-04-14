module vco (  
    input wire clk,  
    input wire [2:0] control,  
    output reg out  
);  
    reg [26:0] counter;  
    reg [26:0] frequency;  

    always @(posedge clk) begin  
        counter <= counter + 1;  
        frequency <= 27'd1 << control; // 2^N Hz frequency generation  
        if (counter >= frequency) begin  
            counter <= 27'd0;  
            out <= ~out; // Toggle output  
        end  
    end  
endmodule