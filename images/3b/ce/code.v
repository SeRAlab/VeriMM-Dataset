module divide_by_8 (  
    input clk,  
    input rst,  
    output reg out  
);  
    reg [2:0] counter;  // 3-bit counter to count up to 7  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 3'b000;  
            out <= 0;  
        end else begin  
            if (counter == 3'b111) begin  
                counter <= 3'b000;  
                out <= ~out;  // toggle output  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  
endmodule