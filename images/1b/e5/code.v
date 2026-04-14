module noise_suppression(input [4:0] in, input clk, output reg [4:0] out);  
    reg [4:0] stable;  
    reg [2:0] count;  
    
    always @(posedge clk) begin  
        if (in == stable) begin  
            count <= count + 1;  
            if (count == 3) begin  
                out <= stable;  
            end  
        end else begin  
            stable <= in;  
            count <= 0;  
        end  
    end  
endmodule