module checksum_calculator(  
    input [7:0] data_in,  
    output reg [3:0] checksum_out,  
    output reg valid  
);  
    always @(*) begin  
        // Calculate the checksum by summing the bits  
        checksum_out = data_in[0] + data_in[1] + data_in[2] + data_in[3] +  
                       data_in[4] + data_in[5] + data_in[6] + data_in[7];  
        // Check if the checksum is valid (for simplicity, valid if checksum is <= 15)  
        valid = (checksum_out <= 4'b1111);  
    end  
endmodule