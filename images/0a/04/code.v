module data_integrity_checker (  
    input wire [7:0] data_in,  
    input wire [3:0] checksum_in,  
    input wire clk,  
    input wire reset,  
    output reg valid  
);  
    reg [8:0] sum;  
    reg [3:0] computed_checksum;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
        end else begin  
            sum = data_in + 1'b1;  
            computed_checksum = ~sum[3:0];  
            if (computed_checksum == checksum_in)  
                valid <= 1;  
            else  
                valid <= 0;  
        end  
    end  
endmodule