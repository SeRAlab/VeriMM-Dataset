module aes_8bit (  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    input wire clk,  
    input wire start,  
    output reg [7:0] data_out,  
    output reg done  
);  
    reg [7:0] state;  
    always @(posedge clk) begin  
        if (start) begin  
            state <= data_in ^ key; // Simple XOR for encryption  
            data_out <= state;  
            done <= 1;  
        end else begin  
            done <= 0;  
        end  
    end  
endmodule