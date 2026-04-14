module deserializer_16bit (  
    input wire clk,  
    input wire rst,  
    input wire [1:0] din,  
    output reg [15:0] dout,  
    output reg valid  
);  
    reg [3:0] bit_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dout <= 16'b0;  
            valid <= 1'b0;  
            bit_count <= 4'b0;  
        end else begin  
            dout <= {dout[13:0], din};  
            bit_count <= bit_count + 1;  
            if (bit_count == 4'b1111) begin  
                valid <= 1'b1;  
            end  
        end  
    end  
endmodule