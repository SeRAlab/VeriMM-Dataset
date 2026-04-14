module checksum_generator_verifier(  
    input [15:0] data_in,  
    input control, // 1 for generate checksum, 0 for verify checksum  
    input [7:0] checksum_in,  
    output reg [7:0] checksum_out,  
    output reg valid  
);  
    integer i;  
    always @(data_in or control or checksum_in) begin  
        if (control) begin  
            // Generate checksum  
            checksum_out = 0;  
            for (i = 0; i < 16; i = i + 1) begin  
                checksum_out = checksum_out + data_in[i];  
            end  
            valid = 1'b0; // Not verifying, so valid is irrelevant  
        end else begin  
            // Verify checksum  
            valid = (checksum_in == checksum_out);  
        end  
    end  
endmodule