module checksum_calculator(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] data_in,  
    output reg [3:0] checksum_out,  
    output reg valid  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            checksum_out <= 4'b0000;  
            valid <= 1'b0;  
        end else begin  
            checksum_out <= data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3];  
            valid <= 1'b1;  
        end  
    end  
endmodule