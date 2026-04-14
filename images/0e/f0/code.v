module clock_divider(  
    input wire clk,  
    input wire rst,  
    output reg divided_clk  
);  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 2'b00;  
            divided_clk <= 1'b0;  
        end else begin  
            count <= count + 1;  
            if (count == 2'b11) begin  
                divided_clk <= ~divided_clk;  
            end  
        end  
    end  
endmodule