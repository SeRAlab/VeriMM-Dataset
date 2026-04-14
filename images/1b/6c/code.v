module checksum_generator_checker(  
    input [7:0] data,  
    input [7:0] given_checksum,  
    output reg [7:0] checksum,  
    output reg valid  
);  
    always @(*) begin  
        checksum = data;  
        valid = (checksum == given_checksum) ? 1'b1 : 1'b0;  
    end  
endmodule