module divide_by_8 (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] in,  
    output reg [7:0] out  
);  
    reg [2:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 8'b0;  
            counter <= 3'b0;  
        end else begin  
            if (counter == 3'b111) begin  
                out <= in >> 3;  
                counter <= 3'b0;  
            end else begin  
                counter <= counter + 1;  
            end  
        end  
    end  
endmodule