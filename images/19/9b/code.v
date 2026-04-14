module clock_divider(  
    input wire clk_in,  
    input wire rst,  
    output reg clk_out  
);  
    reg [1:0] count;  

    always @(posedge clk_in or posedge rst) begin  
        if (rst) begin  
            count <= 2'b00;  
            clk_out <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 2'b11) begin  
                clk_out <= ~clk_out;  
            end  
        end  
    end  
endmodule