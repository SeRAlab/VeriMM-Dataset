module checksum_checker (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire data_ready,  
    input wire [7:0] checksum_in,  
    output reg [7:0] checksum_out,  
    output reg valid  
);  
    reg [7:0] checksum;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            checksum <= 8'b0;  
            checksum_out <= 8'b0;  
            valid <= 1'b0;  
        end else if (data_ready) begin  
            checksum <= (checksum + data_in) % 256;  
            checksum_out <= checksum;  
            valid <= (checksum == checksum_in);  
        end  
    end  
endmodule