module ip_checksum(  
    input [15:0] data_in,  
    input data_valid,  
    input clk,  
    input reset,  
    output reg [15:0] checksum_out,  
    output reg checksum_valid  
);  

    reg [15:0] checksum;  
    reg [15:0] temp;  
    reg valid;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            checksum <= 16'h0000;  
            checksum_valid <= 0;  
        end else if (data_valid) begin  
            temp <= checksum + data_in;  
            checksum <= temp;  
        end else begin  
            checksum_out <= ~checksum;  
            checksum_valid <= 1;  
        end  
    end  
endmodule