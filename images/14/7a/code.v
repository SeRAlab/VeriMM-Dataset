module divide_by_4_counter (  
    input wire clk,  
    input wire reset,  
    output reg [1:0] count_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count_out <= 2'b00;  
        end else begin  
            count_out <= count_out + 1;  
        end  
    end  
endmodule