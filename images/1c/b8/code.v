module checksum_generator_verifier(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire [7:0] checksum_in,  
    output reg valid  
);  
    reg [7:0] checksum;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            checksum <= 8'b0;  
            valid <= 1'b0;  
        end else begin  
            checksum <= 8'b0;  
            for (i = 0; i < 8; i = i + 1) begin  
                checksum = checksum + data_in[i];  
            end  
            valid <= (checksum == checksum_in);  
        end  
    end  
endmodule