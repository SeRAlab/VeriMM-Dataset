module deserializer_16bit (  
    input clk,  
    input rst,  
    input [1:0] din,  
    output reg [15:0] dout,  
    output reg valid  
);  
    reg [3:0] bit_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dout <= 16'b0;  
            bit_count <= 4'b0;  
            valid <= 1'b0;  
        end else begin  
            if (bit_count < 16) begin  
                dout <= {din, dout[15:2]};  
                bit_count <= bit_count + 1;  
                valid <= 1'b0;  
            end  
            if (bit_count == 15) begin  
                valid <= 1'b1;  
            end  
        end  
    end  
endmodule